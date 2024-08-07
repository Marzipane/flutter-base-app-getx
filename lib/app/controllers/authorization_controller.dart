// lib/app/controllers/authorization_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hizmetkalemiapp/app/data/repositories/authorization_repository.dart';
import 'package:hizmetkalemiapp/app/routes/app_routes.dart';
import 'package:hizmetkalemiapp/app/utils/http_error_handler.dart';
import 'package:hizmetkalemiapp/app/utils/token_storage.dart';

import '../data/models/authorization_model.dart'; // Adjust the path as needed

class AuthorizationController extends GetxController {
  final AuthorizationRepository authorizationRepository;
  final TokenStorage tokenStorage = TokenStorage();

  AuthorizationController({Key? key, required this.authorizationRepository});
  var emailFocus = FocusNode().obs;
  var passwordFocus = FocusNode().obs;
  var obscurePassword = true.obs;
  var confirmPasswordFocus = FocusNode().obs;
  final _isLoading = false.obs;
  final _authorizationModel = Rxn<AuthorizationModel>();
  TextEditingController emailController = TextEditingController();
  var passwordController = TextEditingController();

  bool get isLoading => _isLoading.value;
  AuthorizationModel? get authorizationModel => _authorizationModel.value;

  @override
  void onInit() {
    super.onInit();
    _checkAuthenticationStatus();
    ever(_authorizationModel, _redirectBasedOnAuthStatus);
   // authenticate('johnSmith@gmail.com', '12345678');
  }

  Future<void> authenticate() async {
    _isLoading.value = true;
    try {
      final response =
          await authorizationRepository.authenticate(emailController.text, passwordController.text);
      if (response.statusCode == 200) {
        // Parse the response body
        final responseBody = response.body;
        final authorizationModel = authorizationModelFromJson(responseBody);
        // Update the authorizationModel in the controller
        _authorizationModel.value = authorizationModel;
        debugPrint(responseBody);
        if (_authorizationModel.value != null &&
            authorizationModel.token != null) {
          await tokenStorage.saveToken(authorizationModel.token!);
          debugPrint("TOKEN: ${authorizationModel.token}");
          Get.snackbar('Success', 'Authentication successful!');
        }
        // Save token to secure storage.
      } else {
        // Handle different status codes
        final error = HttpErrorHandler.handle(response.statusCode);
        Get.snackbar('Error', error);
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred');
    } finally {
      _isLoading.value = false;
    }
  }


  Future<void> register() async {
    _isLoading.value = true;
    try {
      final response = await authorizationRepository.register(
          email: emailController.text,
          password: emailController.text,
          name: emailController.text,
          mobilePhone: emailController.text);
      if (response.statusCode == 200) {
        // Parse the response body
        final responseBody = response.body;
        final authorizationModel = authorizationModelFromJson(responseBody);
        // Update the authorizationModel in the controller
        _authorizationModel.value = authorizationModel;
        if (_authorizationModel.value != null &&
            authorizationModel.token != null) {
          await tokenStorage.saveToken(authorizationModel.token!);
          debugPrint("TOKEN: ${authorizationModel.token}");
          Get.snackbar('Success', 'Authentication successful!');
        }
        // Save token to secure storage.
      } else {
        // Handle different status codes
        final error = HttpErrorHandler.handle(response.statusCode);
        Get.snackbar('Error', error);
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> user() async {
    _isLoading.value = true;
    try {
      final response =
      await authorizationRepository.user();
      if (response.statusCode == 200) {
        // Parse the response body
        final responseBody = response.body;
        final authorizationModel = authorizationModelFromJson(responseBody);
        // Update the authorizationModel in the controller
        _authorizationModel.value = authorizationModel;
        // Save token to secure storage.
      } else {
        // Handle different status codes
        final error = HttpErrorHandler.handle(response.statusCode);
        Get.snackbar('Error', error);
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _checkAuthenticationStatus() async {
    final token = await tokenStorage.getToken();
    if (token != null) {
      // Token exists, update the authorization model
      _authorizationModel.value =
          AuthorizationModel(token: token); // Or however you want to handle it
    }
  }

  void _redirectBasedOnAuthStatus(AuthorizationModel? authorizationModel) {
    if (authorizationModel != null && authorizationModel.token != null) {
      // User is authenticated
      Get.toNamed(AppRoutes.home);
    } else {
      // User is not authenticated
      // Burayı Login sayfası yapıcaksın
      Get.offAllNamed(AppRoutes.home); // Redirect to login page
    }
  }
}
