import 'package:fhir/r4.dart';

BundleEntry? bundleEntryRequest({
  required FhirCode method,
  String? resourcePath,
  String? canonicalBaseUrl,
  Resource? resource,
}) {
  final methodString = method.toString();
  switch (methodString) {
    case 'GET':
      return resourcePath == null
          ? null
          : BundleEntry(
              request: BundleRequest(
                method: FhirCode('GET'),
                url: FhirUri(resourcePath),
              ),
            );
    case 'POST':
      return resource == null
          ? null
          : BundleEntry(
              resource: resource,
              fullUrl:
                  resource.fhirId == null || resource.path.contains('/null')
                      ? null
                      : FhirUri('$canonicalBaseUrl/${resource.path}'),
              request: BundleRequest(
                method: FhirCode('POST'),
                url: FhirUri(resource.path),
              ),
            );
    case 'PUT':
      return resource == null
          ? null
          : BundleEntry(
              resource: resource,
              fullUrl:
                  resource.fhirId == null || resource.path.contains('/null')
                      ? null
                      : FhirUri('$canonicalBaseUrl/${resource.path}'),
              request: BundleRequest(
                method: FhirCode('PUT'),
                url: FhirUri(resource.path),
              ),
            );
    case 'PATCH':
      return resource == null
          ? null
          : BundleEntry(
              resource: resource,
              fullUrl:
                  resource.fhirId == null || resource.path.contains('/null')
                      ? null
                      : FhirUri('$canonicalBaseUrl/${resource.path}'),
              request: BundleRequest(
                method: FhirCode('PATCH'),
                url: FhirUri(resource.path),
              ),
            );
    case 'get':
      return resourcePath == null
          ? null
          : BundleEntry(
              request: BundleRequest(
                method: FhirCode('GET'),
                url: FhirUri(resourcePath),
              ),
            );
    case 'post':
      return resource == null
          ? null
          : BundleEntry(
              resource: resource,
              fullUrl:
                  resource.fhirId == null || resource.path.contains('/null')
                      ? null
                      : FhirUri('$canonicalBaseUrl/${resource.path}'),
              request: BundleRequest(
                method: FhirCode('POST'),
                url: FhirUri(resource.path),
              ),
            );
    case 'put':
      return resource == null
          ? null
          : BundleEntry(
              resource: resource,
              fullUrl:
                  resource.fhirId == null || resource.path.contains('/null')
                      ? null
                      : FhirUri('$canonicalBaseUrl/${resource.path}'),
              request: BundleRequest(
                method: FhirCode('PUT'),
                url: FhirUri(resource.path),
              ),
            );
    case 'patch':
      return resource == null
          ? null
          : BundleEntry(
              resource: resource,
              fullUrl:
                  resource.fhirId == null || resource.path.contains('/null')
                      ? null
                      : FhirUri('$canonicalBaseUrl/${resource.path}'),
              request: BundleRequest(
                method: FhirCode('PATCH'),
                url: FhirUri(resource.path),
              ),
            );
    default:
      return null;
  }
}
