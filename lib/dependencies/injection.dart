import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:movie_app/data/database/init/database.dart';
import 'package:movie_app/dependencies/injection.config.dart';
import 'package:movie_app/translations/translations.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future initDependencies() async {
  // Intl.defaultLocale = 'en';
  // strings = await Translations.load(Locale('en'));
  _database =
      await $FloorMovieDatabase.databaseBuilder('moves_database.db').build();
  _sharedPreferences = await SharedPreferences.getInstance();
}

SharedPreferences _sharedPreferences;
MovieDatabase _database;
Translations strings;

/// To run code generation use this command in terminal
/// flutter pub run build_runner watch --delete-conflicting-outputs
@injectableInit
void configureInjection(String environment) =>
    $initGetIt(getIt, environment: environment);

abstract class Env {
  static const dev = 'dev';
  static const prod = 'prod';
}
