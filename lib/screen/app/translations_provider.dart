import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@singleton
class TranslationsProvider extends ChangeNotifier {
  Locale _locale;

  set locale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }

  Locale get locale => _locale;
}
