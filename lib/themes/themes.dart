import 'package:flutter/material.dart';
import 'package:simple_budget/themes/colors.dart';

ThemeData themeData = ThemeData(
  fontFamily: '--apple-system',
  brightness: Brightness.dark,
  appBarTheme: const AppBarTheme(backgroundColor: MyColor.primaryColor),
  scaffoldBackgroundColor: MyColor.backgroundColor,
  splashColor: MyColor.primaryColorDark,
  primaryColor: MyColor.primaryColor,
  dividerColor: MyColor.backgroundColorDark,
  //accentColor: accentColors[0],
  iconTheme: const IconThemeData().copyWith(color: MyColor.textColor),
  // fontFamily: 'Roboto',
  textTheme: const TextTheme(
    displayMedium: TextStyle(
      color: MyColor.textColor,
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: TextStyle(
      color: MyColor.textColor,
      fontSize: 12.0,
      fontWeight: FontWeight.w500,
      letterSpacing: 2.0,
    ),
    bodyLarge: TextStyle(
      color: MyColor.textColor,
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.0,
    ),
    bodyMedium: TextStyle(
      color: MyColor.textColor,
      letterSpacing: 1.0,
    ),
  ), colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    error: MyColor.errorColor,
    onError: MyColor.textColor,
    onPrimary: MyColor.backgroundColor,
    onSecondary: MyColor.backgroundColor,
    onSurface: MyColor.textColor,
    primary: MyColor.textColor,
    secondary: MyColor.textColorSecondary,
    surface: MyColor.backgroundColor,
  ),
);