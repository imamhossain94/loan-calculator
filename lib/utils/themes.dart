import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constant.dart';

class AppTheme {

  ThemeData darkTheme() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return ThemeData(
      scaffoldBackgroundColor: scaffoldBackgroundDark,
      backgroundColor: backgroundDark, //050505
      iconTheme: IconThemeData(
        color: Colors.white
      ),
      toggleableActiveColor: primaryColorDark,
      primaryColor: primaryColorDark,
      primarySwatch: Colors.grey,
      canvasColor: Colors.black,
      textTheme: TextTheme(
          headline1: TextStyle(
            color: Colors.white,
          ),
          headline2: TextStyle(
            color: Colors.white54,
          ),
          headline3: TextStyle(
            color: Colors.white,
          )
      ),
      brightness: Brightness.dark,
      dividerTheme: DividerThemeData(
        color: Colors.grey,
        thickness: 0.2,
      ),
      appBarTheme: AppBarTheme(
          brightness: Brightness.dark,
          elevation: 0,
          color: appBarColorDark,
          titleTextStyle: TextStyle(
            color: Colors.white38
          )
      ),
    );
  }

  ThemeData lightTheme() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return ThemeData(
      scaffoldBackgroundColor: scaffoldBackgroundLight,
      backgroundColor: backgroundLight,
      iconTheme: IconThemeData(
          color: Colors.black87
      ),
      toggleableActiveColor: primaryColorLight,
      primaryColor: primaryColorLight,
      primarySwatch: Colors.grey,
      canvasColor: Colors.white,
      textTheme: TextTheme(
          headline1: TextStyle(
            color: Colors.black,
          ),
          headline2: TextStyle(
            color: Colors.black54,
          ),
          headline3: TextStyle(
            color: Colors.white,
          )
      ),
      brightness: Brightness.light,
      dividerTheme: DividerThemeData(
        color: Colors.grey,
        thickness: 0.2,
      ),
      appBarTheme: AppBarTheme(
        brightness: Brightness.light,
          elevation: 0,
          color: appBarColorLight,
          titleTextStyle: TextStyle(
              color: Colors.black54
          )
      ),
    );
  }

}
