// Stub implementation for non-web platforms
Future<void> downloadFile(dynamic bytes, String fileName) async {
  throw UnsupportedError(
    'downloadFile is not supported on this platform. Use mobile file download instead.',
  );
}
