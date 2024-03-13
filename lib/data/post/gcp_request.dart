import 'dart:convert';

import 'package:fhir/r4.dart';
import 'package:fhir_at_rest/r4.dart';
import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart';

import '../../watch_fhir.dart';

/// How the server responds to a post request
Future<Response> postGcpRequest(List<String> path, String fhirVersion) async {
  /// For logging in Cloud Run
  print('postRequest -- path: $path');

  final result = await http.get(Uri.parse(
      'https://iam.mynjinck.com/auth/realms/njinck-dev/.well-known/openid-configuration'));

  final json = jsonDecode(result.body);

  final String? authorization = json['authorization_endpoint'];
  final String? token = json['token_endpoint'];

  if(authorization == null || token == null) {
    return Response.internalServerError(
      body: 'The authorization or token endpoint is not available',
    );
  }

  



  return printResponseFirst('made it to postGcpRequest');

  /// The first entry in path will look something like the following:
  /// projects/my-project/locations/us-central1/datasets/my-dataset/fhirStores/my-fhirstore/fhir/Task/abcdefg
  /// First we split it to get the resourceType
  // final List<String>? splitPath =
  //     path.length != 2 ? null : path.last.split('/');

  // final String? fhirId = splitPath?.removeLast();

  // /// Next to last item in teh list should be a resourceType
  // final String? resourceTypeString = splitPath?.removeLast();

  // /// Convert the resourceTypeString to a R4ResourceType
  // final R4ResourceType? resourceType = resourceTypeString == null
  //     ? null
  //     : Resource.resourceTypeFromString(resourceTypeString);

  // /// We cheeck that it is a resourceType, and if not we return an error
  // if (resourceType == null || fhirId == null || resourceTypeString == null) {
  //   return printResponseFirst('The resourceType passed is not a supported.');
  // } else {
  //   /// Allows us to easily change from full services to communications only. If,
  //   /// for instance in Meld, we're not storing ANY resources except communications
  //   /// and communicationRequests, this is the option we select
  //   if (providerContainer.read(assetsProvider).communicationsOnly) {
  //     switch (resourceTypeString) {
  //       case 'CommunicationRequest':
  //         {
  //           final Resource resource =
  //               await gcpResource(splitPath!, resourceType, fhirId);
  //           return resource is CommunicationRequest
  //               ? postCommunicationRequest(resource, splitPath)
  //               : incorrectType(resourceTypeString, fhirId, resource);
  //         }
  //       default:
  //         return printResponseFirst(
  //             'The resource posted of type $resourceTypeString '
  //             'is not currently supported.');
  //     }
  //   } else {
  //     if (!providerContainer
  //         .read(assetsProvider)
  //         .resourceTypes
  //         .contains(resourceTypeString)) {
  //       return printResponseFirst(
  //           'The resource posted of type $resourceTypeString '
  //           'is not currently supported.');
  //     } else {
  //       final Resource resource =
  //           await gcpResource(splitPath!, resourceType, fhirId);

  //       /// Otherwise, depending on the type of resource that was posted, we
  //       /// respond differently
  //       switch (resourceTypeString) {
  //         case 'ServiceRequest':
  //           return resource is ServiceRequest
  //               ? postServiceRequest(resource, splitPath)
  //               : incorrectType(resourceTypeString, fhirId, resource);
  //         case 'Task':
  //           return resource is Task
  //               ? postTask(resource, splitPath)
  //               : incorrectType(resourceTypeString, fhirId, resource);
  //         case 'CommunicationRequest':
  //           return resource is CommunicationRequest
  //               ? postCommunicationRequest(resource, splitPath)
  //               : incorrectType(resourceTypeString, fhirId, resource);
  //         default:
  //           return printResponseFirst(
  //               'The resource posted of type $resourceTypeString '
  //               'is not currently supported.');
  //       }
  //     }
  //   }
  // }
}

Future<Response> incorrectType(
        String type, String? id, Resource resource) async =>
    printResponseFirst('The was a problem retrieving $type/$id. '
        'Here\'s what we know: ${prettyJson(resource.toJson())}');

Future<Resource> gcpResource(
    List<String> splitPath, R4ResourceType resourceType, String fhirId) async {
  final credentials =
      await getCredentials(providerContainer.read(assetsProvider).allowEmails);

  print(fullGcpUrl(splitPath));

  /// Create the search request
  final resourceRequest = FhirRequest.read(
    /// base fhir url

    base: fullGcpUrl(splitPath),

    /// resource type
    type: resourceType,

    /// ID from URL request
    fhirId: fhirId,
  );

  /// get the response
  final Resource resource = await resourceRequest.request(
      headers: {'Authorization': 'Bearer ${credentials.accessToken.data}'});

  return resource;
}
