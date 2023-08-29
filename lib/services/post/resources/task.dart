import 'package:fhir/r4.dart';
import 'package:fhir_at_rest/r4.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:shelf/shelf.dart';

import '../../../watch_fhir.dart';

Future<Response> postTask(Task task) async {
  final AccessCredentials credentials = await getCredentials();
  final WatchFhirAssets watchFhirAssets = providerContainer.read(assetsProvider);
  final Uri fhirUrl = Uri.parse(watchFhirAssets.fhirUrl);

  final pastCommunicationRequest = FhirRequest.search(
    /// base fhir url
    base: fhirUrl,

    /// resource type
    type: R4ResourceType.Communication,

    /// Reference this task
    parameters: ['based-on=${task.path}'],
  );

  final pastCommunicationResponse = await pastCommunicationRequest.request(
      headers: {'Authorization': 'Bearer ${credentials.accessToken.data}'});

  if (pastCommunicationResponse is! Bundle) {
    return printResponseFirst(
        'Tried to request past Communications about the Task '
        'with ID: ${task.fhirId}, and didn\'t return a Bundle, this is wrong');
  }

  final firstCommunicationIndex = (pastCommunicationResponse.entry
      ?.indexWhere((element) => element.resource is Communication));
  if (firstCommunicationIndex != null && firstCommunicationIndex != -1) {
    return printResponseFirst('Has already sent Communications');
  }

  /// Who is responsible for completing the Task
  final reference = task.owner?.reference;

  /// If there isn't one, return an error
  if (reference == null) {
    return printResponseFirst('The Task with ID: ${task.fhirId} did not have an owner'
        '${task.toJson()}');
  }

  /// Create the search request for a Patient
  final patientRequest = FhirRequest.read(
    /// base fhir url
    base: fhirUrl,

    /// resource type
    type: R4ResourceType.Patient,

    /// ID from URL request
    fhirId: reference.split('/').last,
  );

  /// get the response
  final responsiblePersonResponse = await patientRequest.request(
      headers: {'Authorization': 'Bearer ${credentials.accessToken.data}'});

  /// If there is no responsible person, then return an error
  if (responsiblePersonResponse is! Patient &&
      responsiblePersonResponse is! RelatedPerson) {
    return printResponseFirst('The Responsible Person with Id: '
        '${reference.split("/").last} was not found '
        '${task.toJson()}');
  }

  List<ContactPoint>? contactPoint;

  if (responsiblePersonResponse is Patient) {
    contactPoint = responsiblePersonResponse.telecom;
  }
  if (responsiblePersonResponse is RelatedPerson) {
    contactPoint = responsiblePersonResponse.telecom;
  }

  /// See if there is phone number to send an SMS
  var phoneIndex = contactPoint
      ?.indexWhere((element) => element.system == ContactPointSystem.sms);
  if (phoneIndex == null || phoneIndex == -1) {
    phoneIndex = contactPoint
        ?.indexWhere((element) => element.system == ContactPointSystem.sms);
  }

  /// See if there's an address to send an email
  final emailIndex = contactPoint
      ?.indexWhere((element) => element.system == ContactPointSystem.email);

  /// If there's neither, we return a not found response
  if ((phoneIndex == null || phoneIndex == -1) &&
      (emailIndex == null || emailIndex == -1)) {
    return printResponseFirst('No ability to communication with the person'
        'responsible (id: ${reference.split("/").last}) for Task ${task.fhirId}');
  }

  /// Get the phone number
  final phoneNumber = phoneIndex != null && phoneIndex != -1
      ? contactPoint![phoneIndex].value
      : null;
  final emailAddress = emailIndex != null && emailIndex != -1
      ? contactPoint![emailIndex].value
      : null;

  final communicationRequest = CommunicationRequest(
      basedOn: [task.thisReference],
      status: FhirCode('active'),
      category: [
        CodeableConcept(coding: [
          Coding(
              code: FhirCode('notification'),
              system: FhirUri(
                  'http://terminology.hl7.org/CodeSystem/communication-category'))
        ])
      ],
      priority: FhirCode('routine'),
      payload: [
        CommunicationRequestPayload(
            contentString:
                'MayJuun has assigned you a new Task at ${DateTime.now()}, '
                'click here to complete it: '
                '${watchFhirAssets.cuestionarioUrl}'
                '?requestNumber='
                '${fhirUrl.toString().contains("healthcare.googleapis.com") ? "google/" : ""}'
                '${task.fhirId}'
                '&id=$emailAddress.'),
      ],
      occurrenceDateTime: FhirDateTime(DateTime.now()),
      authoredOn: FhirDateTime(DateTime.now()),
      requester: task.requester,
      recipient: [
        responsiblePersonResponse.thisReference,
      ],
      sender: watchFhirAssets.organizationId == null
          ? null
          : Reference(
              display: 'MayJuun',
              type: FhirUri('Organization'),
              reference: 'Organization/${watchFhirAssets.organizationId}'),
      medium: [
        if (emailAddress != null)
          CodeableConcept(
            coding: [
              Coding(
                system: FhirUri(
                    'http://terminology.hl7.org/CodeSystem/v3-ParticipationMode'),
                code: FhirCode('EMAILWRIT'),
                display: 'email',
              )
            ],
            text: emailAddress,
          ),
        if (phoneNumber != null)
          CodeableConcept(
            coding: [
              Coding(
                system: FhirUri(
                    'http://terminology.hl7.org/CodeSystem/v3-ParticipationMode'),
                code: FhirCode('SMSWRIT'),
                display: 'SMS message',
              ),
            ],
            text: phoneNumber,
          ),
      ]);

  /// Create the search request for a Patient
  final communicationRequestRequest = FhirRequest.create(
    /// base fhir url
    base: fhirUrl,

    /// resource
    resource: communicationRequest,
  );

  final communicationRequestResponse = await communicationRequestRequest
      .request(
          headers: {'Authorization': 'Bearer ${credentials.accessToken.data}'});

  if (communicationRequestResponse is CommunicationRequest) {
    return printResponseFirst(
        'Successfully created CommunicationRequest for ${task.path}');
  } else {
    return printResponseFirst(
        'Unable to create CommunicationRequest for ${task.path}');
  }
}
