Uri fullGcpUrl(List<String> path) {
  final newPath = path.join('/');
  final fullPath = 'https://healthcare.googleapis.com/v1/$newPath';
  return Uri.parse(fullPath);
}
