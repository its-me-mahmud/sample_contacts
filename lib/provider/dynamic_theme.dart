import 'package:flutter/foundation.dart';

class DynamicTheme with ChangeNotifier {
  bool _isDarkMode = false;

  bool get getDarkMode => _isDarkMode;

  void changeDarkMode(bool isDarkMode) {
    _isDarkMode = isDarkMode;
    notifyListeners();
  }
}
