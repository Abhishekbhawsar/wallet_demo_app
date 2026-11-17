import 'package:flutter/material.dart';

abstract final class AppColors {
  static const navy = Color(0xFF102A43);
  static const teal = Color(0xFF00A6A6);
  static const background = Color(0xFFF6F8FB);
  static const success = Color(0xFF128A5B);
  static const danger = Color(0xFFCD3030);
}

ThemeData appTheme() => ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: AppColors.background,
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.teal),
  appBarTheme: const AppBarTheme(
    centerTitle: false,
    backgroundColor: Colors.transparent,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
    ),
  ),
);
