import 'package:fhir/dstu2.dart' as dstu2;
import 'package:fhir/r4.dart' as r4;
import 'package:fhir/r5.dart' as r5;
import 'package:fhir/stu3.dart' as stu3;

// void notifyMalformedRequest(String requestString, String atSign) {
//   final OperationOutcome newOperationOutcome = operationOutcome(
//       'Incorrectly Formed Request',
//       diagnostics: 'Unable to parse this string: $requestString',
//       coding: [
//         Coding(
//           system: FhirUri('http://hl7.org/fhir/operation-outcome'),
//           code: FhirCode('MSG_CANT_PARSE_CONTENT'),
//           display: 'Unable to parse feed',
//         ),
//       ]);
//   atNotify(newOperationOutcome.toJson(), atSign);
// }

dstu2.OperationOutcome dstu2OperationOutcome(
  String issue, {
  String? diagnostics,
  List<dstu2.Coding>? coding,
}) =>
    dstu2.OperationOutcome(
      issue: <dstu2.OperationOutcomeIssue>[
        dstu2.OperationOutcomeIssue(
          severity: dstu2.IssueSeverity.error,
          code: dstu2.FhirCode('value'),
          details: dstu2.CodeableConcept(
            text: issue,
            coding: coding,
          ),
          diagnostics: diagnostics,
        ),
      ],
    );

r4.OperationOutcome r4OperationOutcome(
  String issue, {
  String? diagnostics,
  List<r4.Coding>? coding,
}) =>
    r4.OperationOutcome(
      issue: <r4.OperationOutcomeIssue>[
        r4.OperationOutcomeIssue(
          severity: r4.FhirCode('error'),
          code: r4.FhirCode('value'),
          details: r4.CodeableConcept(
            text: issue,
            coding: coding,
          ),
          diagnostics: diagnostics,
        ),
      ],
    );

r5.OperationOutcome r5OperationOutcome(
  String issue, {
  String? diagnostics,
  List<r5.Coding>? coding,
}) =>
    r5.OperationOutcome(
      issue: <r5.OperationOutcomeIssue>[
        r5.OperationOutcomeIssue(
          severity: r5.FhirCode('error'),
          code: r5.FhirCode('value'),
          details: r5.CodeableConcept(
            text: issue,
            coding: coding,
          ),
          diagnostics: diagnostics,
        ),
      ],
    );

stu3.OperationOutcome stu3OperationOutcome(
  String issue, {
  String? diagnostics,
  List<stu3.Coding>? coding,
}) =>
    stu3.OperationOutcome(
      issue: <stu3.OperationOutcomeIssue>[
        stu3.OperationOutcomeIssue(
          severity: stu3.OperationOutcomeIssueSeverity.error,
          code: stu3.OperationOutcomeIssueCode.value,
          details: stu3.CodeableConcept(
            text: issue,
            coding: coding,
          ),
          diagnostics: diagnostics,
        ),
      ],
    );
