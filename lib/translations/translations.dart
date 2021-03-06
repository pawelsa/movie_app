import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_app/dependencies/injection.dart';
import 'package:movie_app/screen/app/translations_provider.dart';

const List<String> languages = ['en', 'pl'];

class Translations {
  final Locale locale;
  static Map<dynamic, dynamic> _localizedValues;

  String get languageCode => locale.languageCode;

  Translations(this.locale);

  static Translations of(BuildContext context) {
    return Localizations.of<Translations>(context, Translations);
  }

  String text(String key) {
    return _localizedValues[key] ?? "[Error] $key not found";
  }

  static Future<Translations> load(Locale locale) async {
    Translations translations = Translations(locale);
    String jsonContent =
        await rootBundle.loadString("locale/i18n_${locale.languageCode}.json");
    _localizedValues = json.decode(jsonContent);
    _updateLocaleInProvider(locale);
    return translations;
  }

  static void _updateLocaleInProvider(Locale locale) {
    final translationsProvider = getIt<TranslationsProvider>();
    translationsProvider.locale = locale;
  }
}

class TranslationsDelegate extends LocalizationsDelegate<Translations> {
  const TranslationsDelegate();

  @override
  bool shouldReload(LocalizationsDelegate<Translations> old) => false;

  @override
  Future<Translations> load(Locale locale) => Translations.load(locale);

  @override
  bool isSupported(Locale locale) => languages.contains(locale.languageCode);
}
