import 'dart:convert'; // For jsonDecode
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../excetions/api_exception.dart';
import '../../services/api_service.dart';

class AuthorizationRepository extends GetxService {
  final ApiService apiService;

  AuthorizationRepository({required this.apiService});

  /// Authenticate the user with email and password
  Future<Map<String, dynamic>> authenticate(String email, String password) async {
    final body = {
      'email': email,
      'password': password,
    };

    try {
      final response = await apiService.postRequest('/auth', body: body);
      return _parseResponse(response);
    } catch (e) {
      rethrow; // Allow the controller to handle the error
    }
  }

  /// Register a new user
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
    required String mobilePhone,
  }) async {
    final body = {
      'name': name,
      'email': email,
      'password': password,
      'mobile_phone': mobilePhone,
    };

    try {
      final response = await apiService.postRequest('/register', body: body);
      return _parseResponse(response);
    } catch (e) {
      rethrow; // Allow the controller to handle the error
    }
  }

  /// Fetch the current user's data
  Future<Map<String, dynamic>> user() async {
    try {
      final response = await apiService.getRequest('/user', withAuth: true);
      return _parseResponse(response);
    } catch (e) {
      rethrow; // Allow the controller to handle the error
    }
  }

  /// Helper method to parse the HTTP response
  Map<String, dynamic> _parseResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        return Map<String, dynamic>.from(jsonDecode(response.body));
      } catch (e) {
        throw ApiException(response.statusCode, "Invalid response format.");
      }
    } else {
      // Throw an ApiException for non-200 status codes
      throw ApiException(response.statusCode, response.body.isNotEmpty ? response.body : "Unknown error occurred.");
    }
  }
}