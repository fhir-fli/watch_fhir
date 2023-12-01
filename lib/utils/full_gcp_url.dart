Uri fullGcpUrl(List<String> path) =>
    Uri.parse('https://healthcare.googleapis.com/v1/${path.join('/')}');
