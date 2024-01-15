import 'dart:convert';

import 'package:fhir/r4.dart' as dstu2;
import 'package:fhir/r4.dart' as r4;
import 'package:fhir/r4.dart' as r5;
import 'package:fhir/r4.dart' as stu3;
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'watch_fhir.dart';

/// This is the controller for the RESTful API. It defines the routes and
/// handlers for the API. It is called from the server.dart file.
class RestfulController {
  ///Define our getter for our handler
  Handler get handler {
    final router = Router();

    ///
    /// Define our routes
    ///
    /// Basic FHIR route for all verbs, must specify FHIR version
    router.all('/fhir/<dstu2|stu3|r4|r5>',
        (Request request, String fhirVersion) async {
      return Response.ok('${request.method} made to the generic endpoint');
    });

    /// Extended route, may include things like ResourceType and ID
    router.all('/fhir/<dstu2|stu3|r4|r5>/<ignored|.*>',
        (Request request, String fhirVersion, String resourceType) async {
      return Response.ok('${request.method} made to the extended endpoint');
    });

    /// Same as above, but in case there's a "/" at the end of the URL
    router.all('/fhir/<dstu2|stu3|r4|r5>/<ignored|.*>/',
        (Request request, String fhirVersion, String resourceType) async {
      return Response.ok(
          '${request.method} made to the extended endpoint but ended with "/"');
    });

    /// This is the endpoint for evaluating a fhirpath expression
    router.all('/fhir/<dstu2|stu3|r4|r5>/\$fhirpath', (Request request) async {
      return Response.ok('${request.method} made to the fhirpath endpoint');
    });

    /// Same as above, but in case there's a "/" at the end of the URL
    router.all('/fhir/<dstu2|stu3|r4|r5>/\$fhirpath/', (Request request) async {
      return Response.ok('${request.method} made to the fhirpath endpoint');
    });

    /// This is specifically for allowing Pub/Sub from GCP
    router.post('/fhir/gcp/<dstu2|stu3|r4|r5>',
        (Request request, String fhirVersion) async {
      final requestString = await request.readAsString();
      final path = pathFromPayload(requestString, fhirVersion);
      if (path.isNotEmpty && path.length == 2) {
        return postGcpRequest(path, fhirVersion);
      }
      return Response.ok('${request.method} made to the GCP endpoint');
    });

    ///You can catch all verbs and use a URL-parameter with a regular expression
    ///that matches everything to catch app.
    router.all('/<ignored|.*>', (Request request) {
      // TODO(Dokotela): because GCP keeps resending until it gets a 200, we return
      // a 200 during development. This should be changed to a 404 when we're ready
      // to deploy in prod.
      // return Response.notFound('Page not found');
      return Response.ok('Page not found');
    });

    return router.call;
  }
}

/// Checks on the path from the payload. It shold be passed the payload (which
/// in our case is the body of the message). It will check to ensure it's not
/// an empty string, then will look for the data from the payload.message.data
/// field (which is 64bit encoded). So we decode all of that to make it
/// human readable, check some things to ensure it's the proper format, and
/// as long as it is, returns a list of the format, [ResourceType, Id]
List<String> pathFromPayload(String requestString, String fhirVersion) {
  if (requestString.isNotEmpty) {
    final payloadData = jsonDecode(requestString)?['message']?['data'];

    if (payloadData != null) {
      final String data = utf8.fuse(base64).decode(payloadData);
      final Map<String, dynamic> dataMap = jsonDecode(data);
      print('dataMap: $dataMap');
      final String resourceFullPath = dataMap['resource_full_path'];
      final List<String> dataList = resourceFullPath.split('/');
      print('dataList: $dataList');
      if (dataList.length > 1) {
        final shouldBeAType = dataList[dataList.length - 2];
        if ((fhirVersion == 'dstu2' &&
                dstu2.resourceTypeFromStringMap.keys.contains(shouldBeAType)) ||
            (fhirVersion == 'r4' &&
                r4.resourceTypeFromStringMap.keys.contains(shouldBeAType)) ||
            (fhirVersion == 'r5' &&
                r5.resourceTypeFromStringMap.keys.contains(shouldBeAType)) ||
            (fhirVersion == 'stu3' &&
                stu3.resourceTypeFromStringMap.keys.contains(shouldBeAType))) {
          return [shouldBeAType, resourceFullPath];
        }
      }
    }
  }
  return [];
}
