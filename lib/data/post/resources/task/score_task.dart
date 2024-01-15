import 'package:fhir/r4.dart';
import 'package:fhir_at_rest/r4.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:shelf/shelf.dart';
import 'package:watch_fhir/watch_fhir.dart';

Future<Response> scoreTask(Task task, List<String> path) async {
  print('Score Task: ${task.fhirId}');
  List<String> paths = [];

  /// Look through each input in the Task to see if it's a Resource
  var index = task.input?.indexWhere(
      (element) => element.valueUri.toString().contains('Measure'));
  if (index != null && index != -1) {
    paths.add(task.input![index].valueUri.toString());
  }
  index = task.input?.indexWhere((element) =>
      element.valueReference?.reference?.toString().contains('Measure') ??
      false);
  if (index != null && index != -1) {
    paths.add(task.input![index].valueReference!.reference.toString());
  }

  /// Look through each output in the Task to see if it's a Resource
  /// Resources are represented in the output in two ways (for our purposes)
  ///
  /// 1. A reference to a resource
  /// 2. A URI that starts with the resource type
  for (var output in task.output ?? <TaskOutput>[]) {
    if (resourceTypeFromStringMap.keys
        .contains(output.valueUri.toString().split('/').first)) {
      paths.add(output.valueUri.toString());
    } else if (output.valueReference?.reference != null) {
      paths.add(output.valueReference!.reference.toString());
    }
  }

  /// If there is no Patient listed in this Task, we can't score it
  if (task.for_?.reference == null) {
    return Response.ok('No patient found');
  } else {
    final Uri fhirUrl = fullGcpUrl(path);

    /// Add the patient to the list of resources to retrieve
    paths.add(task.for_!.reference!);

    /// Create the list of bundleEntries so we can request them all at once
    final bundleEntries = paths
        .map(
            (e) => bundleEntryRequest(method: FhirCode('GET'), resourcePath: e))
        .toList();
    bundleEntries.removeWhere((element) => element == null);

    /// Create the transaction bundle to request the resources
    final Bundle newTransactionBundle = Bundle(
      type: FhirCode('transaction'),
      entry: bundleEntries.map((e) => e!).toList(),
    );

    /// Create the transaction request
    final transactionRequest = FhirRequest.transaction(
      /// base fhir url
      base: fhirUrl,

      /// bundle to send
      bundle: newTransactionBundle,
    );

    /// Get the credentials to make requests
    final AccessCredentials credentials = await getCredentials();

    /// Send the transaction request
    final transactionResponse = await transactionRequest.request(
        headers: {'Authorization': 'Bearer ${credentials.accessToken.data}'});

    /// If the response is not a bundle, we can't score it
    if (transactionResponse is! Bundle) {
      return printResponseFirst(
          'Could not get the resources needed to complete Task');
    } else {
      /// Find the Measure, Patient, and QuestionnaireResponses
      final measureIndex = transactionResponse.entry?.indexWhere(
          (element) => element.resource?.resourceTypeString == 'Measure');
      final patientIndex = transactionResponse.entry?.indexWhere(
          (element) => element.resource?.resourceTypeString == 'Patient');
      final responses = <QuestionnaireResponse>[];
      for (var entry in transactionResponse.entry ?? <BundleEntry>[]) {
        if (entry.resource != null && entry.resource is QuestionnaireResponse) {
          responses.add(entry.resource! as QuestionnaireResponse);
        }
      }

      /// If we can't find the Measure, Patient, or QuestionnaireResponses, we can't score it
      if (measureIndex == null || measureIndex == -1) {
        return printResponseFirst('No Measure Found');
      }
      if (patientIndex == null || patientIndex == -1) {
        return printResponseFirst('No Patient Found');
      }
      if (responses.isEmpty) {
        return printResponseFirst('No QuestionnaireResponse Found');
      }

      final oldMeasureReportIndex = transactionResponse.entry?.indexWhere(
          (element) => element.resource?.resourceTypeString == 'MeasureReport');
      final oldMeasureReport =
          oldMeasureReportIndex == null || oldMeasureReportIndex == -1
              ? null
              : transactionResponse.entry?[oldMeasureReportIndex].resource;
      final measureReportId =
          oldMeasureReport == null || oldMeasureReport is! MeasureReport
              ? null
              : oldMeasureReport.fhirId;

      /// Create the MeasureReport
      final measureReport = createMeasureReportFromResponses(
        measure: transactionResponse.entry![measureIndex].resource! as Measure,
        responses: responses,
        fhirUrl: fhirUrl.toString(),
        patient: transactionResponse.entry![patientIndex].resource! as Patient,
        report: measureReportId == null
            ? null
            : MeasureReport(
                fhirId: measureReportId,
                measure: FhirCanonical(fhirUrl),
                period: Period(start: FhirDateTime(DateTime.now()))),
      );

      final completeTask = task.copyWith(status: FhirCode('completed'));

      final Bundle finalBundle = Bundle(
        type: FhirCode('transaction'),
        entry: [
          bundleEntryRequest(
              method: FhirCode('PUT'),
              resourcePath: completeTask.path,
              resource: completeTask)!,
          bundleEntryRequest(
              method: FhirCode('PUT'),
              resourcePath: measureReport.path,
              resource: measureReport)!,
        ],
      );

      /// Create the transaction request
      final transactionRequest = FhirRequest.transaction(
        /// base fhir url
        base: fhirUrl,

        /// bundle to send
        bundle: finalBundle,
      );

      /// Send the transaction request
      final Resource finalResult = await transactionRequest.request(
          headers: {'Authorization': 'Bearer ${credentials.accessToken.data}'});

      final countSuccess = finalResult is Bundle &&
          finalResult.entry
                  ?.where((element) =>
                      element.response?.status == '201' ||
                      element.response?.status == '200')
                  .length !=
              2;

      return printResponseFirst(countSuccess
          ? 'Successful Update'
          : 'Something Went Wrong with the Update\n${finalResult.toJson()}');
    }
  }
}
