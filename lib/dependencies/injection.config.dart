// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../screen/app/app_provider.dart';
import '../screen/app/translations_provider.dart';
import '../widgets/bottom_navigation/bottom_navigation_provider.dart';

/// adds generated dependencies
/// to the provided [GetIt] instance

GetIt $initGetIt(
  GetIt get, {
  String environment,
  EnvironmentFilter environmentFilter,
}) {
  final gh = GetItHelper(get, environment, environmentFilter);

  // Eager singletons must be registered in the right order
  gh.singleton<AppProvider>(AppProvider());
  gh.singleton<BottomNavigationProvider>(BottomNavigationProvider());
  gh.singleton<TranslationsProvider>(TranslationsProvider());
  return get;
}
