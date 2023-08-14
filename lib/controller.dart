import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class ListeningController {
  ///Define our getter for our handler
  Handler get handler {
    final router = Router();

    /// Define our routes
    /// The main routes will be the active version of FHIR (in our case currently, R4)
    router.all('/', (Request request) async {
      return Response.ok('Post Request made, but payload incorrect');
    });

    router.all('/fhir/', (Request request) async {
      return Response.ok('Post Request made, but payload incorrect');
    });

    router.all('/fhir', (Request request) async {
      return Response.ok('Post Request made, but payload incorrect');
    });

    /// Routes Specifically for R5
    ///
    /// Routes Specifically for R4
    /// 
    /// Routes Specifically for Stu3
    /// 
    /// Routes Specifically for Dstu2

    ///You can catch all verbs and use a URL-parameter with a regular expression
    ///that matches everything to catch app.
    router.all('/<ignored|.*>', (Request request) {
      // return Response.notFound('Page not found');
      return Response.ok('Page not found');
    });

    return router;
  }
}
