import 'package:flutter/material.dart';
import 'package:myshop/config/colors.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  backgroundColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
  primaryColor: primaryColor,
  primaryColorBrightness: Brightness.dark,
  accentColor: accentColor,
  accentColorBrightness: Brightness.dark,
  fontFamily: "poppins",
  buttonTheme: ButtonThemeData(
    buttonColor: buttonColor,
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    padding: EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 20,
    ),
  ),
);
