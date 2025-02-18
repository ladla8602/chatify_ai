import 'ar_AR.dart';
import 'en_US.dart';
import 'es_ES.dart';
import 'fr_FR.dart';
import 'ja_JP.dart';
import 'ru_Ru.dart';

abstract class AppTranslations {
  static Map<String, Map<String, String>> translationsKeys = {
    "en_US": enUS,
    "es_ES": esES,
    "fr_FR": frFR,
    "ar_AR": arAR,
    "ru_RU": ruRU,
    "ja_JP": jaJP,
  };
}
