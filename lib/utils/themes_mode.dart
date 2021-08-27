import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constant.dart';

class ThemesMode {
  static bool isDarkMode;

  void init(BuildContext context) {
    isDarkMode = Theme.of(context).brightness == Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: isDarkMode == true? scaffoldBackgroundDark: scaffoldBackgroundLight,
      systemNavigationBarIconBrightness: isDarkMode == true?Brightness.light: Brightness.dark,
      statusBarColor: isDarkMode == true?appBarColorDark : appBarColorLight,
      statusBarBrightness: isDarkMode == true?Brightness.light: Brightness.dark,
      statusBarIconBrightness: isDarkMode == true?Brightness.light: Brightness.dark,
    ));
  }
}

