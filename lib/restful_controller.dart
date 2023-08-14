import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class RestfulController {
  ///Define our getter for our handler
  Handler get handler {
    final router = Router();

    /// Define our routes
    /// The main routes will be the active version of FHIR (in our case currently, R4)
    router.all('/fhir/<dstu2|stu3|r4|r5>',
        (Request request, String fhirVersion) async {
      return Response.ok('Post Request made, but payload incorrect');
    });
    router.all('/fhir/<dstu2|stu3|r4|r5>/<ignored|.*>',
        (Request request, String fhirVersion, String resourceType) async {
      return Response.ok('Post Request made, but payload incorrect');
    });

    ///You can catch all verbs and use a URL-parameter with a regular expression
    ///that matches everything to catch app.
    router.all('/<ignored|.*>', (Request request) {
      // return Response.notFound('Page not found');
      return Response.ok('Page not found');
    });

    return router;
  }
}
