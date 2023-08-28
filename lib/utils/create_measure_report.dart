// Package imports:
import 'dart:developer';

import 'package:fhir/r4.dart';
import 'package:fhir_path/fhir_path.dart';

final _socialComplexity = '';

MeasureReport createMeasureReportFromBundle({
  required Measure measure,
  required Bundle bundle,
  required String fhirUrl,
  required Patient patient,
  MeasureReport? report,
}) {
  final responses = <QuestionnaireResponse>[];
  for (var entry in bundle.entry ?? <BundleEntry>[]) {
    if (entry.resource != null && entry.resource is QuestionnaireResponse) {
      responses.add(entry.resource! as QuestionnaireResponse);
    }
  }

  return _createMeasureReport(
    measure,
    bundle,
    responses,
    fhirUrl,
    patient,
    report,
  );
}

MeasureReport createMeasureReportFromResponses({
  required Measure measure,
  required List<QuestionnaireResponse> responses,
  required String fhirUrl,
  required Patient patient,
  MeasureReport? report,
}) {
  /// Create  bundle that contains all of the Questionnaires
  Bundle bundle = const Bundle(entry: []);
  for (var response in responses) {
    bundle = bundle.copyWith(entry: [
      if (bundle.entry != null) ...bundle.entry!,
      BundleEntry(resource: response)
    ]);
  }

  return _createMeasureReport(
    measure,
    bundle,
    responses,
    fhirUrl,
    patient,
    report,
  );
}

MeasureReport _createMeasureReport(
  Measure measure,
  Bundle bundle,
  List<QuestionnaireResponse> responses,
  String fhirUrl,
  Patient patient,
  MeasureReport? report,
) {
  print('_createMeasureReport');

  /// Clear the current MeasureReport
  MeasureReport measureReport = report?.copyWith(
        status: FhirCode('complete'),
        type: FhirCode('individual'),
        group: [],
        period: Period(end: FhirDateTime.fromDateTime(DateTime.now())),
        measure: FhirCanonical('$fhirUrl/Measure/${measure.fhirId}'),
        subject: patient.thisReference,
      ) ??
      MeasureReport(
        status: FhirCode('complete'),
        type: FhirCode('individual'),
        group: [],
        period: Period(end: FhirDateTime.fromDateTime(DateTime.now())),
        measure: FhirCanonical('$fhirUrl/Measure/${measure.fhirId}'),
        subject: patient.thisReference,
      );

  print('Length of MeasureGroup: ${measure.group?.length}');
  int i = 1;

  /// For each Group in Measure
  for (var measureGroup in measure.group ?? <MeasureGroup>[]) {
    print('Loop number times: $i');
    i++;
    String? responsePath;

    final questionnairePath = measureGroup.code?.coding?.first.code.toString();
    if (questionnairePath != null) {
      final responseIndex = responses.indexWhere((element) =>
          element.questionnaire.toString().contains(questionnairePath));
      responsePath = responseIndex == -1 ? null : responses[responseIndex].path;
    }
    print(
        'Set questionnairePath: $questionnairePath\n  + responsePath: $responsePath');

    /// Add one group to the MeasureReport
    final List<MeasureReportGroup> newGroups = [
      ...measureReport.group ?? [],
      MeasureReportGroup(
          code: CodeableConcept(
              coding: measureGroup.description?.contains('Social Complexity') ??
                      false
                  ? [
                      Coding(
                          system: FhirUri(
                              '$fhirUrl/CodeSystem/?name=$_socialComplexity'))
                    ]
                  : responsePath == null
                      ? null
                      : [Coding(code: FhirCode(responsePath))],
              text: measureGroup.description),
          stratifier: measureGroup.population == null ||
                  (measureGroup.population?.isEmpty ?? true)
              ? null
              : [])
    ];

    print('copying over measureReport with newGroups');
    measureReport = measureReport.copyWith(group: newGroups);
    print('new groups updated: $newGroups');

    print(
        'Length of MeasureGroupPopulation: ${measureGroup.population?.length}');
    int j = 1;

    /// Look through the populations in Measure.population
    for (var population in measureGroup.population ?? <MeasurePopulation>[]) {
      print('number of times through measureGroupPopulations: $j');
      j++;

      /// Currently only supports FHIRPath
      if (population.criteria.language ==
          FhirExpressionLanguage.text_fhirpath) {
        final pathExpression = population.criteria.expression;
        if (pathExpression != null) {
          /// For these measures, the return values from FHIRPath should be
          /// a list of a single string. It is semi-colon delimted, the
          /// first value should be a number, the second two values may
          /// be null, or may ve Strings
          // ignore: prefer_final_locals
          List<String> pathResult = [];
          try {
            // TODO(Dokotela): come back and fix the environment
            print('PathExpression: $pathExpression');
            final result = walkFhirPath(
              context: bundle.toJson(),
              pathExpression: pathExpression,
              environment: {'%patient': patient.toJson()},
              resource: bundle.toJson(),
            );
            if (result.isNotEmpty) {
              result.forEach(print);
              pathResult.addAll(result.first.toString().split(';'));
            }
          } catch (e) {
            print(
                '---ERROR---: $e\n   measureGroup.description : ${measureGroup.description}\n   population.description : ${population.description}');
            log(
              e.toString(),

              // TODO(Dokotela): fix this, or convert to a Hint()
              // hint: {
              //   'measureGroup.description': measureGroup.description,
              //   'population.description': population.description,
              //   // 'walkFhirPath': walkFhirPath(
              //   //   context: bundle.toJson(),
              //   //   pathExpression: pathExpression,
              //   //   environment: {
              //   //     '%patient': patient.toJson(),
              //   //   },
              //   //   resource: bundle.toJson(),
              //   // )
              // }
            );
            pathResult.addAll([
              '-1',
              'indeterminate',
              'There was an error in the scoring, please contact us'
            ]);
          }
          String? value;
          String? code;
          double? score;

          print('parsing path result of: $pathResult');

          if (pathResult.isNotEmpty && double.tryParse(pathResult[0]) != null) {
            score = double.tryParse(pathResult[0]);
          }
          if (pathResult.length > 1) {
            if (['high', 'medium', 'low', 'indeterminate']
                .contains(pathResult[1])) {
              code = '${pathResult[1]}-risk';
            } else {
              value = pathResult[1];
            }
          } else {
            code = 'none';
            value = 'No risk level associated';
          }
          if (pathResult.length > 2) {
            value = pathResult[2];
          }

          /// Populations from Measure are being represented as a list of
          /// Stratum within the Stratifier of the MeasureReport.population
          /// (confusing, I agree)
          ///
          print('Value: $value');
          print('Code: $code');
          print('Score: $score');

          MeasureReportGroup? newGroup = measureReport.group?.last;
          if (newGroup != null) {
            print('newGroup is not null');
            newGroup = newGroup.copyWith(stratifier: [
              ...newGroup.stratifier ?? [],
              MeasureReportStratifier(
                code: [CodeableConcept(text: population.description)],
                stratum: [
                  MeasureReportStratum(
                    /// This is the actual score/subscore
                    measureScore: score == null
                        ? null
                        : Quantity(value: FhirDecimal(score)),

                    component: value == null && code == null
                        ? null
                        : [
                            MeasureReportComponent(
                              value: CodeableConcept(
                                coding: [
                                  Coding(
                                    code: FhirCode(value ?? code),
                                    display: value ?? code,
                                  )
                                ],
                              ),
                              code: CodeableConcept(
                                coding: [
                                  Coding(
                                    system: code == null
                                        ? null
                                        : FhirUri(
                                            'mayjuun.com/fhir/ValueSet/low_medium_high_indeterminate_risk_none'),
                                    code: FhirCode(code ?? value),
                                    display: code ?? value,
                                  ),
                                ],
                              ),
                            ),
                            MeasureReportComponent(
                              value:
                                  CodeableConcept(text: population.description),
                              code:
                                  CodeableConcept(text: population.description),
                            )
                          ],
                  )
                ],
              ),
            ]);
            print('setting new measure report group: $newGroup');

            /// Update MeasureReportGroups, removing the last value if possible
            /// (which is what was just modified)
            final List<MeasureReportGroup> oldGroups =
                measureReport.group?.toList() ?? [];
            if (oldGroups.isNotEmpty) {
              oldGroups.removeLast();
            }

            final List<MeasureReportGroup> newGroups = oldGroups.toList();
            newGroups.add(newGroup);

            measureReport = measureReport.copyWith(group: newGroups);
          }
        }
      }
    }
    for (var group in measureReport.group ?? <MeasureReportGroup>[]) {
      print(group.toJson());
    }

    print('...Finished Creating MeasureReport');
  }
  return measureReport.newIdIfNoId() as MeasureReport;
}
