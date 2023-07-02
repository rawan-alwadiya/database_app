import 'package:flutter/material.dart';
import 'package:database_app/prefs/shared_pref_controller.dart';

class LanguageProvider extends ChangeNotifier{
  String language=SharedPrefController().getValueFor<String>(key: PrefKeys.language.name) ?? 'en';

  void changeLanguage(){
    language = language == 'en'? 'ar':'en';
    SharedPrefController().changeLanguage(language);
    notifyListeners();
  }
}