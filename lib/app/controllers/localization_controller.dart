import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/app_constants.dart';

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

    if (savedLocale != null && savedLocale.isNotEmpty) {
      // If a saved locale is found, split and use it.
      final parts = savedLocale.split('_');
      final savedLocaleObject = Locale(parts[0], parts.length > 1 ? parts[1] : '');
      updateLocale(_isSupportedLocale(savedLocaleObject)
          ? savedLocaleObject
          : AppConstants.fallbackLocale);
    } else {
      // Get the phone's default locale using Platform.localeName.
      final String defaultLocale = Platform.localeName; // e.g., "en_US" or "tr_TR"
      Locale? deviceLocale;

      // Validate and split the defaultLocale.
      if (defaultLocale.isNotEmpty) {
        final parts = defaultLocale.split('_');
        if (parts.isNotEmpty) {
          deviceLocale = Locale(parts[0], parts.length > 1 ? parts[1] : '');
        }
      }

      // Check if the deviceLocale is supported by the app.
      if (deviceLocale != null && _isSupportedLocale(deviceLocale)) {
        updateLocale(deviceLocale);
      } else {
        // Fallback to the default locale if the device locale is not supported.
        updateLocale(AppConstants.fallbackLocale);
      }
    }
  }

  bool _isSupportedLocale(Locale locale) {
    return AppConstants.supportedLocales.contains(locale);
  }

  void updateLocale(Locale newLocale) async {
    if (_locale.value != newLocale) {
      _locale.value = newLocale;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        AppConstants.storedLocaleKey,
        '${newLocale.languageCode}_${newLocale.countryCode ?? ''}',
      );
      Get.updateLocale(newLocale);
    }
  }

  void resetLocale() async {
    updateLocale(AppConstants.fallbackLocale);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.storedLocaleKey);
  }
}
