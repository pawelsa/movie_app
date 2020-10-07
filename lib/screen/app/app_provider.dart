import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:movie_app/dependencies/injection.dart';

@injectable
class AppProvider extends ChangeNotifier {
  bool isInitialised = false;

  void init() async {
    if (!isInitialised) {
      await initDependencies();
      isInitialised = true;
      notifyListeners();
    }
  }
}
