import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@singleton
class BottomNavigationProvider extends ChangeNotifier {
  bool _isVisible = true;
  int _currentlySelected = 0;

  set isVisible(bool isVisible) {
    if (_isVisible != isVisible) {
      _isVisible = isVisible;
      notifyListeners();
    }
  }

  bool get isVisible => _isVisible;

  set currentlySelected(int selected) {
    if (currentlySelected != selected) {
      _currentlySelected = selected;
      notifyListeners();
    }
  }

  int get currentlySelected => _currentlySelected;
}
