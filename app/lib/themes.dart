import 'package:flutter/material.dart';

ThemeData globalTheme(BuildContext context) => ThemeData(
  useMaterial3: true,
  fontFamily: 'Cera Pro',
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),

  inputDecorationTheme: InputDecorationTheme(
    contentPadding: const EdgeInsets.all(20.0),
    border: OutlineInputBorder(
      borderSide: const BorderSide(width: 3),
      borderRadius: BorderRadius.circular(10.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade300, width: 3),
      borderRadius: BorderRadius.circular(10.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(width: 3),
      borderRadius: BorderRadius.circular(10.0),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.red, width: 3),
      borderRadius: BorderRadius.circular(10.0),
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.black,
      minimumSize: const Size(double.infinity, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    ),
  ),
);

class AppColors {
  static const Color primary = Colors.deepOrange;
  static const Color primaryMuted = Color.fromRGBO(254, 232, 206, 1);
}
