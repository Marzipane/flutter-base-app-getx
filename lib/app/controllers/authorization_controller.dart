// lib/app/controllers/authorization_controller.dart
import 'dart:convert'; // For jsonEncode
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samplename/app/data/repositories/authorization_repository.dart';
import 'package:samplename/app/routes/app_routes.dart';
import 'package:samplename/app/utils/token_storage.dart';
import '../data/models/authorization_model.dart';
import '../excetions/api_exception.dart'; // Adjust the path as needed

class AuthorizationController extends GetxController {
  final AuthorizationRepository authorizationRepository;
  final TokenStorage tokenStorage = TokenStorage();

  AuthorizationController({required this.authorizationRepository});

  /// FocusNodes for text fields
  var emailFocus = FocusNode().obs;
  var passwordFocus = FocusNode().obs;
  var confirmPasswordFocus = FocusNode().obs;

  /// Toggles password visibility
  var obscurePassword = true.obs;

  /// Loading indicator
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  /// Authorization Model
  final _authorizationModel = Rxn<AuthorizationModel>();
  AuthorizationModel? get authorizationModel => _authorizationModel.value;

  /// Controllers for input fields
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _checkAuthenticationStatus();
    // Whenever _authorizationModel changes, evaluate whether to redirect
    ever(_authorizationModel, _redirectBasedOnAuthStatus);
  }

  /// Authenticate the user
  Future<void> authenticate() async {
    _isLoading.value = true;
    try {
      // Instead of an http.Response, we get a Map<String, dynamic>
      final data = await authorizationRepository.authenticate(
        emailController.text,
        passwordController.text,
      );

      // Convert Map to JSON string if your parser needs JSON input
      final jsonString = jsonEncode(data);
      final authModel = authorizationModelFromJson(jsonString);

      _authorizationModel.value = authModel;

      // If the token is present, store it
      if (authModel.token != null) {
        await tokenStorage.saveToken(authModel.token!);
        debugPrint("TOKEN: ${authModel.token}");
        Get.snackbar('Success', 'Authentication successful!');
      }
    } on ApiException catch (e) {
      // Handle specific status codes in the controller
      // This is where you can decide UI navigation or messages
      if (e.statusCode == 400) {
        Get.snackbar("Error", "Invalid input for authentication.");
        // For example, go back to the previous page:
        Get.back();
      } else if (e.statusCode == 401) {
        Get.snackbar("Error", "Unauthorized. Incorrect email or password.");
      } else {
        Get.snackbar("Error", "Unexpected error: ${e.message}");
      }
    } catch (e) {
      // Catch any other errors
      Get.snackbar('Error', 'An unexpected error occurred');
    } finally {
      _isLoading.value = false;
    }
  }

  /// Register a new user
  Future<void> register() async {
    _isLoading.value = true;
    try {
      final data = await authorizationRepository.register(
        email: emailController.text,
        password: passwordController.text,
        name: emailController.text,
        mobilePhone: emailController.text,
      );

      final jsonString = jsonEncode(data);
      final authModel = authorizationModelFromJson(jsonString);

      _authorizationModel.value = authModel;

      if (authModel.token != null) {
        await tokenStorage.saveToken(authModel.token!);
        debugPrint("TOKEN: ${authModel.token}");
        Get.snackbar('Success', 'Registration successful!');
      }
    } on ApiException catch (e) {
      // Handle specific status codes in the controller
      if (e.statusCode == 400) {
        Get.snackbar("Error", "Invalid registration data.");
        // Example: you could do a custom behavior
      } else if (e.statusCode == 409) {
        Get.snackbar("Error", "Email already exists.");
      } else {
        Get.snackbar("Error", "Unexpected error: ${e.message}");
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred');
    } finally {
      _isLoading.value = false;
    }
  }

  /// Fetch the current user's data
  Future<void> user() async {
    _isLoading.value = true;
    try {
      final data = await authorizationRepository.user();
      final jsonString = jsonEncode(data);
      final authModel = authorizationModelFromJson(jsonString);

      _authorizationModel.value = authModel;
    } on ApiException catch (e) {
      // For example: if statusCode = 401, we could log out or go back
      if (e.statusCode == 401) {
        Get.snackbar("Error", "Session expired. Please log in again.");
        Get.back(); // For instance, navigate back to login page
      } else {
        Get.snackbar("Error", "User Error: ${e.message}");
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred');
    } finally {
      _isLoading.value = false;
    }
  }

  /// Check if a token exists in storage and update the model
  Future<void> _checkAuthenticationStatus() async {
    final token = await tokenStorage.getToken();
    if (token != null) {
      // Create an AuthorizationModel from the existing token
      _authorizationModel.value = AuthorizationModel(token: token);
    }
  }

  /// Redirect based on authentication status
  void _redirectBasedOnAuthStatus(AuthorizationModel? model) {
    if (model != null && model.token != null) {
      // User is authenticated
      Get.toNamed(AppRoutes.home);
    } else {
      // User is not authenticated
      // Example: redirect to login; adjust route as needed
      Get.offAllNamed(AppRoutes.home);
    }
  }
}