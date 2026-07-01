import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark; // Default to dark as requested
  final _storage = const FlutterSecureStorage();

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    String? theme = await _storage.read(key: 'theme_mode');
    if (theme == 'light') {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.dark;
    }
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.dark) {
      _themeMode = ThemeMode.light;
      await _storage.write(key: 'theme_mode', value: 'light');
    } else {
      _themeMode = ThemeMode.dark;
      await _storage.write(key: 'theme_mode', value: 'dark');
    }
    notifyListeners();
  }
}
