class ApiException implements Exception {
  final int statusCode; // HTTP status code
  final String message; // Custom error message

  ApiException(this.statusCode, this.message);

  @override
  String toString() => "ApiException($statusCode): $message";
}