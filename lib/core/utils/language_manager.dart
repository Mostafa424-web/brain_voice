import 'package:brain_voice/app_constance.dart';
import 'package:flutter/widgets.dart';

enum LanguageType { english, arabic }

const Locale arabicLocale = Locale("ar", "SA");
const Locale englishLocale = Locale("en", "US");
const String assets_path_localisations = "assets/translations";

extension LanguageTypeExtension on LanguageType {
  String getValue() {
    switch (this) {
      case LanguageType.english:
        return AppConstance.english;
      case LanguageType.arabic:
        return AppConstance.arabic;
    }
  }
}
