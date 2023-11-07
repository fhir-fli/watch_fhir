import 'package:fhir/dstu2.dart' as dstu2;
import 'package:fhir_at_rest/dstu2.dart' as dstu2_request;
import 'package:fhir/r4.dart' as r4;
import 'package:fhir_at_rest/r4.dart' as r4_request;
import 'package:fhir/r5.dart' as r5;
import 'package:fhir_at_rest/r5.dart' as r5_request;
import 'package:fhir/stu3.dart' as stu3;
import 'package:fhir_at_rest/stu3.dart' as stu3_request;

import '../../watch_fhir.dart';

// TODO(Dokotela): add authentication headers
final Map<String, String> headers = <String, String>{};

Future<dstu2.Resource> forwardDstu2Request(
    dstu2_request.FhirRequest request) async {
  dstu2.Resource resource = dstu2OperationOutcome(
      "Unable to make request, sorry, that's all we know.");
  for (var i = 0; i < numberOfTries; i++) {
    resource = await request.request(headers: headers);
    if (resource is! dstu2.OperationOutcome ||
        (resource.issue.first.code.toString() != 'informational')) {
      return resource;
    } else {
      await timeoutDelay(i);
    }
  }
  return resource;
}

Future<r4.Resource> forwardR4Request(r4_request.FhirRequest request) async {
  r4.Resource resource =
      r4OperationOutcome("Unable to make request, sorry, that's all we know.");
  for (var i = 0; i < numberOfTries; i++) {
    resource = await request.request(headers: headers);
    if (resource is! r4.OperationOutcome ||
        (resource.issue.first.code.toString() != 'informational')) {
      return resource;
    } else {
      await timeoutDelay(i);
    }
  }
  return resource;
}

Future<r5.Resource> forwardR5Request(r5_request.FhirRequest request) async {
  r5.Resource resource =
      r5OperationOutcome("Unable to make request, sorry, that's all we know.");
  for (var i = 0; i < numberOfTries; i++) {
    resource = await request.request(headers: headers);
    if (resource is! r5.OperationOutcome ||
        (resource.issue.first.code.toString() != 'informational')) {
      return resource;
    } else {
      await timeoutDelay(i);
    }
  }
  return resource;
}

Future<stu3.Resource> forwardStu3Request(
    stu3_request.FhirRequest request) async {
  stu3.Resource resource = stu3OperationOutcome(
      "Unable to make request, sorry, that's all we know.");
  for (var i = 0; i < numberOfTries; i++) {
    resource = await request.request(headers: headers);
    if (resource is! stu3.OperationOutcome ||
        (resource.issue.first.code.toString() != 'informational')) {
      return resource;
    } else {
      await timeoutDelay(i);
    }
  }
  return resource;
}
