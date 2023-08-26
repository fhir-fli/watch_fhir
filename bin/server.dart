import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf_io.dart' as shelf_io;

import 'package:get_it/get_it.dart';
import 'package:watch_fhir/watch_fhir.dart';
import 'package:yaml/yaml.dart';

/// GetIt required for singleton injection of client asset dependencies
/// This includes color scheme, unique text, unique asset paths, etc
GetIt getIt = GetIt.instance;

Future<void> main() async {
  final File serviceAccountFile = File('assets/assets.yaml');
  final String serviceAccountFileText = await serviceAccountFile.readAsString();
  final YamlMap yaml = loadYaml(serviceAccountFileText);
  final Map<String, dynamic> json = jsonDecode(jsonEncode(yaml));
  final WatchFhirAssets watchFhirAssets = WatchFhirAssets.fromJson(json);
  getIt.registerSingleton<WatchFhirAssets>(watchFhirAssets);

  /// If the "PORT" environment variable is set, lisconfig['clientApis'][element]ten to it. Otherwise, 8080.
  /// https://cloud.google.com/run/docs/reference/container-contract#port
  final port = int.parse(Platform.environment['PORT'] ?? '8080');

  /// Instantiate Controller to Listen
  final RestfulController restfulController = RestfulController();

  /// Create server
  /// See https://pub.dev/documentation/shelf/latest/shelf_io/serve.html
  final server = await shelf_io.serve(
    /// See https://pub.dev/documentation/shelf/latest/shelf/logRequests.html
    restfulController.handler,
    InternetAddress.anyIPv4, // Allows external connections
    port,
  );

  server.autoCompress = true;

  /// Server on message
  print('☀️ Serving at http://${server.address.host}:${server.port} ☀️');
}
