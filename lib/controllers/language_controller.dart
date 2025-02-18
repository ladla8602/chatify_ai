import 'dart:ui';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/language_model.dart';

class LanguageController extends GetxController {
  final _storage = GetStorage();
  final String _storageKey = 'language';

  final Rx<String> selectedLanguage = 'English (US)'.obs;

  final List<LanguageModel> languages = [
    LanguageModel(
      name: 'English (US)',
      flag: '🇺🇸',
      languageCode: 'en',
      countryCode: 'US',
    ),
    LanguageModel(
      name: 'Spanish',
      flag: '🇪🇸',
      languageCode: 'es',
      countryCode: 'ES',
    ),
    LanguageModel(
      name: 'French',
      flag: '🇫🇷',
      languageCode: 'fr',
      countryCode: 'FR',
    ),
    LanguageModel(
      name: 'Russian',
      flag: '🇷🇺',
      languageCode: 'ru',
      countryCode: 'RU',
    ),
    LanguageModel(
      name: 'Japanese',
      flag: '🇯🇵',
      languageCode: 'ja',
      countryCode: 'JP',
    ),
    LanguageModel(
      name: 'Arabic',
      flag: '🇦🇪',
      languageCode: 'ar',
      countryCode: 'AE',
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    final savedLanguage = _storage.read(_storageKey);
    if (savedLanguage != null) {
      selectedLanguage.value = savedLanguage;
    }
  }

  void changeLanguage(LanguageModel language) {
    selectedLanguage.value = language.name;
    _storage.write(_storageKey, language.name);
    Get.updateLocale(Locale(language.languageCode, language.countryCode));

    Get.snackbar(
      'success'.tr,
      'language_changed'.tr,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
}
