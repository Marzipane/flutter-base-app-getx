import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/app_constants.dart';

class LocalizationController extends GetxController implements GetxService {
  final Rx<Locale> _locale = Rx<Locale>(AppConstants.fallbackLocale);
  Locale get locale => _locale.value;

  @override
  void onInit() {
    super.onInit();
    loadSavedLocale();
  }

  Future<void> loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString(AppConstants.storedLocaleKey);
    if (savedLocale != null) {
      final parts = savedLocale.split('_');
      updateLocale(Locale(parts[0], parts[1]));
    } else {
      Get.updateLocale(AppConstants.fallbackLocale);
    }
  }

  void updateLocale(Locale newLocale) async {
    if (_locale.value != newLocale) {
      _locale.value = newLocale;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.storedLocaleKey, '${newLocale.languageCode}_${newLocale.countryCode}');
      Get.updateLocale(newLocale);
    }
  }

  void resetLocale() async {
    updateLocale(AppConstants.fallbackLocale);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.storedLocaleKey);
  }
}


