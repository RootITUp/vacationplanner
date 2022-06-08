import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  bool get isDarkMode => themeMode == ThemeMode.dark;
  bool get isLightMode => themeMode == ThemeMode.light;

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
    fontFamily: 'Poppins',
    scaffoldBackgroundColor: Colors.transparent,
    unselectedWidgetColor: const Color(0xFF6d597a),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.all(const Color(0xFF6d597a)),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      selectionHandleColor: Color(0xFF6d597a),
    ),
    hintColor: const Color(0xffeaac8b),
    colorScheme: const ColorScheme.dark(),
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.transparent,
    fontFamily: 'Poppins',
    hintColor: const Color(0xFF6d597a),
    textSelectionTheme: const TextSelectionThemeData(
      selectionHandleColor: Color(0xFF6d597a),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.all(const Color(0xFF6d597a)),
    ),
    colorScheme: const ColorScheme.light(),
  );
}
