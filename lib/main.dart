import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:samplename/app/bindings/initial_binding.dart';
import 'app/services/firebase_api_service.dart';
import 'app/utils/app_colors.dart';
import 'app/controllers/localization_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/services/localization_service.dart';
import 'app/utils/app_constants.dart';
import 'app/utils/app_text_themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Map<String, Map<String, String>> translationKeys =
      await initializeTranslationKeys();
  // this will work only if you connected firebase to project and config files were generated
  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotifications();
  runApp(MyApp(
    translationKeys: translationKeys,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.translationKeys});

  final Map<String, Map<String, String>> translationKeys;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocalizationController>(
        builder: (localizationController) {
      return GetMaterialApp(
        title: 'sample app',
        initialBinding: InitialBinding(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          textTheme:  AppTextThemes.poppinsTextTheme,
          scaffoldBackgroundColor:  AppColors.scaffoldBackgroundColor,
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        getPages: AppPages.pages,
        initialRoute: AppRoutes.home,
        supportedLocales: AppConstants.supportedLocales,
        translations: LocalizationService(translationKeys: translationKeys),
        locale: localizationController.locale,
        fallbackLocale: AppConstants.fallbackLocale,
      );
    });
  }
}
