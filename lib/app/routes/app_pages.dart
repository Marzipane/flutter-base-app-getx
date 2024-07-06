import 'package:get/get_navigation/get_navigation.dart';
import 'package:hizmetkalemiapp/views/home_screen/home_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
    ),
  ];
}
