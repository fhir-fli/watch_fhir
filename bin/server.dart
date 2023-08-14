import 'dart:io';

import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:watch_fhir/controller.dart';

void main(List<String> args) async {
  /// If the "PORT" environment variable is set, lisconfig['clientApis'][element]ten to it. Otherwise, 8080.
  /// https://cloud.google.com/run/docs/reference/container-contract#port
  final port = int.parse(Platform.environment['PORT'] ?? '8080');

  /// Instantiate Controller to Listen
  final listeningController = ListeningController();

  /// Create server
  /// See https://pub.dev/documentation/shelf/latest/shelf_io/serve.html
  final server = await shelf_io.serve(
    /// See https://pub.dev/documentation/shelf/latest/shelf/logRequests.html
    listeningController.handler,
    InternetAddress.anyIPv4, // Allows external connections
    port,
  );

  server.autoCompress = true;

  /// Server on message
  print('☀️ Serving at http://${server.address.host}:${server.port} ☀️');
}
