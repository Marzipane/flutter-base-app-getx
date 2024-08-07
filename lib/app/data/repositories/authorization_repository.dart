import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../services/api_service.dart';

class AuthorizationRepository {
  final ApiService apiService;

  AuthorizationRepository({required this.apiService});

  Future<http.Response> authenticate(String email, String password) async {
    debugPrint("email: $email, password: $password");
    final body = {
      'email': email,
      'password': password,
    };

    final response = await apiService.postRequest(
      '/auth',
      body: body,
    );
    debugPrint(response.body);
    return response;
  }

  // register
  Future<http.Response> register({
    required String email,
    required String password,
    required String name,
    required String mobilePhone
  }) async {
    final body = {
      'name' : name,
      'email': email,
      'password': password,
      'user_type' : "oldubiil",
      'mobile_phone' : mobilePhone
    };

    final response = await apiService.postRequest(
      '/register',
      body: body,
    );

    return response;
  }

  Future<http.Response> user() async {

    final response = await apiService.getRequest(
      '/user',
      withAuth: true

    );

    return response;
  }
}


