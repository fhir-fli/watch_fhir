// Package imports:
import 'dart:developer';

import 'package:fhir/r4.dart';
import 'package:fhir_path/fhir_path.dart';

/// This function will take the given parameters and run them through the
/// FHIRPath engine, producing a list of results
List<dynamic> fhirPathUtil({
  String? expression,
  FhirExtension? extension,
  Element? element,
  Resource? resource,
  Map<String, dynamic>? env,
}) {
  /// If no element or expression is passed, there is no FHIRPath expression
  /// to evaluate, so an empty list is returned
  if (element == null && extension == null && expression == null) {
    return [];
  }

  /// We're almost ready to apply FHIRPath to the resources, but we need to
  /// get the FHIRPath expression first
  if (expression == null) {
    if (extension != null &&
        extension.valueExpression?.language ==
            FhirExpressionLanguage.text_fhirpath) {
      expression = extension.valueExpression?.expression;
    }
    if (expression == null || expression == '') {
      final extensionIndex = element?.extension_?.indexWhere((element) =>
          element.valueExpression != null &&
          element.valueExpression?.language ==
              FhirExpressionLanguage.text_fhirpath);
      if (extensionIndex != null && extensionIndex != -1) {
        final expressionExtension = element!.extension_![extensionIndex];
        expression = expressionExtension.valueExpression!.expression;
      }
    }
  }

  /// Check if the expression evaluated to null, and if so, return empty list
  if (expression == null) {
    return [];
  }

  try {
    return walkFhirPath(
      context: resource?.toJson(),
      pathExpression: expression,
      environment: env,
      resource: resource?.toJson(),
    );
  } catch (e, stack) {
    log(e.toString(), stackTrace: stack);
    return [];
  }
}
