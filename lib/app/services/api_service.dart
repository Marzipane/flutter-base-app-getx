import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../utils/token_storage.dart'; // Make sure the path is correct

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

  Future<http.Response> uploadRequest(
      String endpoint, {
        bool withAuth = false,
        Map<String, String>? headers,
        List<Map<String, File>>? files,
        Map<String, dynamic>? fields,
      }) async {
    final Map<String, String> requestHeaders = await _buildHeaders(withAuth, headers);

    // Ensure the content-type is set to multipart/form-data for file uploads
    requestHeaders['Content-Type'] = 'multipart/form-data';

    final http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('$baseUrl$endpoint'));
    request.headers.addAll(requestHeaders);

    // Add fields to the request
    if (fields != null) {
      fields.forEach((String key, dynamic value) {
        request.fields[key] = value.toString();
      });
    }

    // Add files to the request
    if (files != null) {
      for (Map<String, File> file in files) {
        for (MapEntry<String, File> entry in file.entries) {
          final String fileField = entry.key;
          final File fileObject = entry.value;
          final http.MultipartFile fileContent = await http.MultipartFile.fromPath(fileField, fileObject.path);
          request.files.add(fileContent);
        }
      }
    }

    final http.StreamedResponse streamedResponse = await request.send();
    final http.Response response = await http.Response.fromStream(streamedResponse);

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
