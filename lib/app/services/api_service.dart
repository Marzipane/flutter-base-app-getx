import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:samplename/app/utils/token_storage.dart'; // Make sure the path is correct

class ApiService {
  final String baseUrl;
  final Map<String, String> commonHeaders;
  final TokenStorage tokenStorage;

  ApiService({
    required this.baseUrl,
    required this.commonHeaders,
    required this.tokenStorage,
  });

  Future<http.Response> getRequest(String endpoint, {bool withAuth = false, Map<String, String>? headers}) async {
    final requestHeaders = await _buildHeaders(withAuth, headers);
    final response = await http.get(Uri.parse('$baseUrl$endpoint'), headers: requestHeaders);
    return response;
  }

  Future<http.Response> postRequest(String endpoint, {bool withAuth = false, Map<String, String>? headers, Map<String, dynamic>? body}) async {
    final requestHeaders = await _buildHeaders(withAuth, headers);
    final response = await http.post(Uri.parse('$baseUrl$endpoint'), headers: requestHeaders, body: jsonEncode(body));
    return response;
  }

  Future<http.Response> putRequest(String endpoint, {bool withAuth = false, Map<String, String>? headers, Map<String, dynamic>? body}) async {
    final requestHeaders = await _buildHeaders(withAuth, headers);
    final response = await http.put(Uri.parse('$baseUrl$endpoint'), headers: requestHeaders, body: jsonEncode(body));
    return response;
  }

  Future<http.Response> deleteRequest(String endpoint, {bool withAuth = false, Map<String, String>? headers, Map<String, dynamic>? body}) async {
    final requestHeaders = await _buildHeaders(withAuth, headers);
    final response = await http.delete(Uri.parse('$baseUrl$endpoint'), headers: requestHeaders, body: jsonEncode(body));
    return response;
  }

  Future<Map<String, String>> _buildHeaders(bool withAuth, Map<String, String>? headers) async {
    final requestHeaders = {...commonHeaders, if (headers != null) ...headers};
    if (withAuth) {
      final token = await tokenStorage.getToken();
      if (token != null) {
        requestHeaders['Authorization'] = 'Bearer $token';
      }
    }
    return requestHeaders;
  }
}
