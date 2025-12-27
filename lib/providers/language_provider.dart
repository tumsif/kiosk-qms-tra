import 'package:flutter/widgets.dart';

class LanguageProvider extends ChangeNotifier {
  Language language = Language.english;

  void toggleLanguage() {
    if (language == Language.english) {
      language = Language.swahili;
    } else {
      language = Language.english;
    }
    notifyListeners();
  }

  void setLanguage(Language lang) {
    language = lang;
    notifyListeners();
  }
}

enum Language {
  swahili,
  english
}