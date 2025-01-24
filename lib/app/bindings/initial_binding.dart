import 'package:get/get.dart';
import '../controllers/authorization_controller.dart';
import '../controllers/localization_controller.dart';
import '../data/repositories/authorization_repository.dart';
import '../services/api_service.dart';
import '../utils/token_storage.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Here is where you create and put all your dependencies
    // ApiService
    final apiService = ApiService(
      baseUrl: 'http://example.com/api/',
      commonHeaders: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      tokenStorage: TokenStorage(),
    );

    // Controllers & Repositories
    Get.put(LocalizationController());
    final authorizationRepository =
    AuthorizationRepository(apiService: apiService);
    Get.put(AuthorizationController(
        authorizationRepository: authorizationRepository));
  }
}
