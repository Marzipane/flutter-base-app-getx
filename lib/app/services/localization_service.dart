
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../common/app_constants.dart';
import '../models/language_model.dart';

class LocalizationService extends Translations {
  late final Map<String, Map<String, String>> translationKeys;
  LocalizationService({required this.translationKeys});

  @override
  Map<String, Map<String, String>> get keys {
    return translationKeys;
  }
}

Future<Map<String, Map<String, String>>> initializeTranslationKeys() async {
  Map<String, Map<String, String>> languages = {};
  for (LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues = await rootBundle
        .loadString('assets/languages/${languageModel.languageCode}.json');
    Map<String, dynamic> _mappedJson = json.decode(jsonStringValues);
    Map<String, String> _json = {};
    _mappedJson.forEach((key, value) {
      _json[key] = value.toString();
    });
    languages['${languageModel.languageCode}_${languageModel.countryCode}'] =
        _json;
  }
  print(languages);
  return languages;
}
