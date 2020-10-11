import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:movie_app/dependencies/injection.dart';
import 'package:movie_app/resources/colors.dart';
import 'package:movie_app/resources/dimen.dart';
import 'package:movie_app/screen/app/app_provider.dart';
import 'package:movie_app/screen/app/translations_provider.dart';
import 'package:movie_app/screen/splash_screen/splash_screen_page.dart';
import 'package:movie_app/translations/translations.dart';
import 'package:movie_app/widgets/bottom_navigation.dart';
import 'package:movie_app/widgets/conditional.dart';
import 'package:provider/provider.dart';

void main() {
  configureInjection(Env.dev);
  runApp(PrepareApp());
}

class PrepareApp extends StatefulWidget {
  @override
  _PrepareAppState createState() => _PrepareAppState();
}

class _PrepareAppState extends State<PrepareApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: getIt<AppProvider>(),
      child: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          appProvider.init();
          return Conditional(
            condition: appProvider.isInitialised,
            ifBuilder: (context) => MyApp(),
            elseBuilder: (context) => child,
          );
        },
        child: SplashScreenPage(),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: getIt<TranslationsProvider>(),
      child: Consumer<TranslationsProvider>(
        builder: (context, translationsProvider, child) {
          return IndexedStack(
            textDirection: TextDirection.ltr,
            index: translationsProvider.locale == null ? 1 : 0,
            children: <Widget>[
              MaterialApp(
                title: 'Flutter Demo',
                localizationsDelegates: [
                  const TranslationsDelegate(),
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate
                ],
                supportedLocales: const [Locale('pl'), Locale('en')],
                theme: ThemeData(
                    backgroundColor: AppColors.background,
                    accentColor: AppColors.accent,
                    unselectedWidgetColor: AppColors.unselected,
                    bottomNavigationBarTheme: BottomNavigationBarThemeData(
                        backgroundColor: Colors.white,
                        elevation: Dimen.bottomNavigationElevation,
                        selectedItemColor: AppColors.selected,
                        unselectedItemColor: AppColors.unselected,
                        selectedIconTheme: IconThemeData(
                          color: AppColors.selected,
                          opacity: 1.0,
                          size: Dimen.selectedBottomNavigationBarIconSize,
                        ),
                        unselectedIconTheme: IconThemeData(
                          color: AppColors.unselected,
                          opacity: 0.7,
                          size: Dimen.iconSize,
                        )),
                    primarySwatch: Colors.blue,
                    fontFamily: 'ITCAvantGardeStd'),
                home: MyHomePage(),
              ),
              if (translationsProvider.locale == null) SplashScreenPage(),
            ],
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentPage = 0;

  final List pages = [
    Center(
      child: Container(
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: Container(
          width: 100,
          height: 100,
          color: Colors.orange,
        ),
      ),
    ),
    Center(
      child: Container(
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: Container(
          width: 100,
          height: 100,
          color: Colors.pink,
        ),
      ),
    ),
    Center(
      child: Container(
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
      ),
    )
  ];

  @override
  Widget build(BuildContext context) {
    strings = Translations.of(context);
    return Scaffold(
      body: Stack(
        children: [
          pages[_currentPage],
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomNavigation(
              onPressed: (index) {
                if (index != _currentPage) {
                  setState(() {
                    _currentPage = index;
                  });
                }
              },
              currentIndex: _currentPage,
              items: [
                BottomNavigationItemData(Icons.home),
                BottomNavigationItemData(Icons.web),
                BottomNavigationItemData(Icons.person)
              ],
            ),
          )
        ],
      ),
    );
  }
}
