import 'package:fhir/r4.dart';
import 'package:fhir_at_rest/r4.dart';
import 'package:shelf/shelf.dart';

import '../../watch_fhir.dart';

/// How the server responds to a post request
Future<Response> postGcpRequest(List<String> path) async {
  /// For logging in Cloud Run
  print('postRequest -- path: $path');

  final R4ResourceType? resourceType = Resource.resourceTypeFromString(path[0]);

  if (resourceType == null) {
    return Response.ok('"${path[0]}" is not a supported resourceType.');
  } else {
    /// Allows us to easily change from full services to communications only. If,
    /// for instance in Meld, we're not storing ANY resources except communications
    /// and communicationRequests, this is the option we select
    if (providerContainer.read(assetsProvider).communicationsOnly) {
      switch (path[0]) {
        case 'CommunicationRequest':
          {
            final Resource resource = await gcpResource(path);
            return resource is CommunicationRequest
                ? postCommunicationRequest(resource)
                : incorrectType(path[0], path[1], resource);
          }
        default:
          return Response.ok('The resource posted of type ${path[0]} '
              'is not currently supported.');
      }
    } else {
      final Resource resource = await gcpResource(path);

      /// Otherwise, depending on the type of resource that was posted, we
      /// respond differently
      switch (path[0]) {
        case 'ServiceRequest':
          return resource is ServiceRequest
              ? postServiceRequest(resource)
              : incorrectType(path[0], path[1], resource);
        case 'Task':
          return resource is Task
              ? postTask(resource)
              : incorrectType(path[0], path[1], resource);
        case 'CommunicationRequest':
          return resource is CommunicationRequest
              ? postCommunicationRequest(resource)
              : incorrectType(path[0], path[1], resource);
        default:
          return Response.ok('The resource posted of type ${path[0]} '
              'is not currently supported.');
      }
    }
  }
}

Future<Response> incorrectType(
        String type, String? id, Resource resource) async =>
    Response.ok(
        'The was a problem retrieving $type/$id. Here\'s what we know: ${prettyJson(resource.toJson())}');

Future<Resource> gcpResource(List<String> path) async {
  final credentials = await getCredentials(true);

  /// Create the search request
  final resourceRequest = FhirRequest.read(
    /// base fhir url
    base: Uri.parse(providerContainer.read(assetsProvider).fhirUrl),

    /// resource type
    type: Resource.resourceTypeFromString(path[0])!,

    /// ID from URL request
    fhirId: path[1],
  );

  /// get the response
  final Resource resource = await resourceRequest.request(
      headers: {'Authorization': 'Bearer ${credentials.accessToken.data}'});

  return resource;
}
