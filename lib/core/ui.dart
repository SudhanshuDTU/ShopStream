import 'package:flutter/material.dart';

class AppColors {
  static MaterialColor accent = Colors.teal;
  static Color text = Colors.black;
  static Color textLight = Colors.blueGrey;
  static Color white = Colors.white;
}

class Themes {
  static ThemeData defaultTheme = ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: AppColors.accent,
        secondary: AppColors.accent,
      ),
      scaffoldBackgroundColor: AppColors.white,
      appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: AppColors.white,
          iconTheme: IconThemeData(color: AppColors.text),
          titleTextStyle: TextStyle(color: AppColors.text, fontSize: 18)));
}

class TextStyles {
  static TextStyle heading1 = TextStyle(
      fontWeight: FontWeight.bold, fontSize: 48, color: AppColors.text);

  static TextStyle heading2 = TextStyle(
      fontWeight: FontWeight.bold, fontSize: 32, color: AppColors.text);

  static TextStyle heading3 = TextStyle(
      fontWeight: FontWeight.bold, fontSize: 24, color: AppColors.text);

  static TextStyle body1 = TextStyle(
      fontWeight: FontWeight.normal, fontSize: 18, color: AppColors.text);

  static TextStyle body2 = TextStyle(
      fontWeight: FontWeight.normal, fontSize: 16, color: AppColors.text);
  static TextStyle buttonstyle = TextStyle(
      fontWeight: FontWeight.w600, fontSize: 18, color: AppColors.text);
}
