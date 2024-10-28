import 'package:flutter/material.dart';

import '../data/models/language_model.dart';


class AppConstants {
  static List<LanguageModel> languages = [
    LanguageModel(
        languageName: 'Türkçe', countryCode: 'TR', languageCode: 'tr'),
    LanguageModel(
        languageName: 'English', countryCode: 'US', languageCode: 'en'),
  ];

  static List<Locale> supportedLocales = languages
      .map((language) => Locale(language.languageCode, language.countryCode))
      .toList();

  static Locale fallbackLocale = supportedLocales[0];
  static String appName = "";
  // UNCOMMENT THIS IF YOU ARE USING LOCAL HOST
  // static const String appBaseUrl = "http://10.0.2.2:8000/";a
  static const String appBaseUrl = "";
  static const String storedLocaleKey= "";

}
