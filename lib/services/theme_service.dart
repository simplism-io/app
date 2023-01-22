import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:system_theme/system_theme.dart';

ThemeData light = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Colors.orange,
    onPrimary: Colors.white,
    secondary: Colors.grey,
    onSecondary: Colors.white,
    background: Colors.transparent,
    onBackground: Color.fromARGB(255, 77, 77, 77),
    error: Colors.red,
    onError: Colors.white,
    surface: Color.fromARGB(255, 247, 246, 246),
    onSurface: Color.fromARGB(255, 77, 77, 77),
  ),
  fontFamily: 'OpenSans',
);

ThemeData dark = ThemeData(
  scaffoldBackgroundColor: Colors.black,
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: Colors.orange,
    onPrimary: Colors.white,
    secondary: Colors.grey,
    onSecondary: Colors.white,
    background: Colors.transparent,
    onBackground: Colors.white,
    error: Colors.red,
    onError: Colors.white,
    surface: Color.fromARGB(255, 48, 48, 48),
    onSurface: Colors.white,
  ),
  fontFamily: 'OpenSans',
);

class ThemeService extends ChangeNotifier {
  final String key = "theme";
  late bool _darkTheme;

  bool get darkTheme => _darkTheme;

  ThemeService() {
    _darkTheme = SystemTheme.isDarkMode;
    loadFromPrefs();
  }

  toggleTheme() {
    _darkTheme = !_darkTheme;
    saveToPrefs();
  }

  loadFromPrefs() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _darkTheme = pref.getBool(key) ?? SystemTheme.isDarkMode;
    if (kDebugMode) {
      print('Theme loaded from storage. DarkTheme is: $_darkTheme');
    }
    notifyListeners();
  }

  saveToPrefs() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool(key, _darkTheme);
    if (kDebugMode) {
      print('Theme saved in storage. DarkTheme is: $_darkTheme');
    }
    notifyListeners();
  }
}
