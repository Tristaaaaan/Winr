import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier() : super(false); // Initial state is light mode (false)

  static final ThemeData lightMode = ThemeData(
    colorScheme: const ColorScheme.light(
      surface: Colors.white,
      primary: Color(0xff574667),
      onPrimaryContainer: Color(0xff3592E7),
      secondary: Color(0xff2DD7A4),
      tertiary: Color(0xffB47820),
      primaryContainer: Color(0xffF3F8FE),
      inversePrimary: Colors.black,
      inverseSurface: Colors.black,
      tertiaryContainer: Color(0xffDF9652),
      primaryFixedDim: Color(0xff4D5652),
      tertiaryFixedDim: Color(0xffF8D675),
    ),
  );

  static final ThemeData darkMode = ThemeData(
    colorScheme: ColorScheme.dark(
      surface: Colors.black,
      primary: Colors.white,
      secondary: Colors.white,
      tertiary: const Color.fromARGB(255, 180, 180, 180).withValues(alpha: 0.2),
      inversePrimary: Colors.grey.shade900,
      tertiaryContainer: const Color(0xff939cc4),
      primaryFixedDim: Colors.white,
    ),
  );

  ThemeData get currentTheme => state ? darkMode : lightMode;
  void toggleTheme() {
    state = !state;
  }

  void setTheme(bool isDark) {
    state = isDark;
  }
}

final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier();
});
