import 'package:flutter/material.dart';

final lightTheme = ThemeData.light().copyWith(
  primaryColor: Color(0xff4CAF50), // Primary color
  scaffoldBackgroundColor: Colors.white, // Background for screens
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white, // AppBar background
    foregroundColor: Colors.black, // AppBar text and icon colors
    surfaceTintColor: Colors.white, // Surface tint
    elevation: 0, // AppBar elevation
    iconTheme: IconThemeData(color: Colors.black), // Icon color in AppBar
    titleTextStyle: TextStyle(
      color: Colors.black, // AppBar title color
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  ),
  dividerTheme: DividerThemeData(
    color: Colors.grey.shade300,
  ),

  drawerTheme: DrawerThemeData(
    backgroundColor: Colors.white, // Drawer background
    scrimColor: Colors.black12, // Scrim color when drawer is open
  ),

  colorScheme: ColorScheme.light(
    primary: Color(0xff4CAF50), // Primary color
    secondary: Colors.greenAccent, // Accent color
    surface: Colors.grey[100]!, // Surface background
    background: Colors.white, // Overall background
    error: Colors.red, // Error color
    onPrimary: Colors.white, // Text on primary color
    onSecondary: Colors.black, // Text on secondary color
    onSurface: Colors.black, // Text on surface
    onBackground: Colors.black, // Text on background
    onError: Colors.white, // Text on error color
    outline: Colors.grey.shade200, // Outline color
  ),
  iconTheme: IconThemeData(
    color: Colors.black, // Icon colors
  ),
  textTheme: TextTheme(
    bodyMedium: TextStyle(color: Colors.black), // Title styles
    titleLarge: TextStyle(color: Colors.black),
    titleMedium: TextStyle(color: Colors.black87), // Normal text styles
    titleSmall: TextStyle(color: Colors.black87),
    bodySmall: TextStyle(color: Colors.grey),
    headlineLarge: TextStyle(color: Colors.black87), // Captions
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Color(0xff4CAF50), // Button background
    textTheme: ButtonTextTheme.primary, // Button text style
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xff4CAF50), // Button background
      foregroundColor: Colors.white, // Text color
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    fillColor: Colors.grey[200], // Input field background
    filled: true,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: Color(0xff4CAF50),
    unselectedItemColor: Colors.grey,
    showSelectedLabels: true,
    showUnselectedLabels: true,
  ),
);

final darkTheme = ThemeData.dark().copyWith(
  primaryColor: Colors.blue, // Primary color
  scaffoldBackgroundColor: Colors.black, // Background for screens
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black87, // AppBar background
    foregroundColor: Colors.white, // AppBar text and icon colors
    elevation: 0, // AppBar elevation
    surfaceTintColor: Colors.black87,
  ),
  drawerTheme: DrawerThemeData(
    backgroundColor: Colors.black87, // Drawer background
    scrimColor: Colors.black54, // Scrim color when drawer is open
  ),
  colorScheme: ColorScheme.dark(
      primary: Colors.blue, // Primary color
      secondary: Colors.lightBlueAccent, // Accent color
      surface: Colors.grey[850]!, // Surface background
      background: Colors.black, // Overall background
      error: Colors.redAccent, // Error color
      onPrimary: Colors.white, // Text on primary color
      onSecondary: Colors.white, // Text on secondary color
      onSurface: Colors.white, // Text on surface
      onBackground: Colors.white, // Text on background
      onError: Colors.black, // Text on error color
      outline: Colors.grey[850]!),
  iconTheme: IconThemeData(
    color: Colors.white, // Icon colors
  ),
  textTheme: TextTheme(
    bodyMedium: TextStyle(color: Colors.white), // Title styles
    titleLarge: TextStyle(color: Colors.white),
    titleMedium: TextStyle(color: Colors.white70), // Normal text styles
    titleSmall: TextStyle(color: Colors.white70),
    bodySmall: TextStyle(color: Colors.grey), // Captions
    headlineLarge: TextStyle(color: Colors.white),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.blue, // Button background
    textTheme: ButtonTextTheme.primary, // Button text style
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue, // Button background
      foregroundColor: Colors.white, // Text color
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    fillColor: Colors.grey[800], // Input field background
    filled: true,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.black,
    selectedItemColor: Colors.blue,
    unselectedItemColor: Colors.grey,
    showSelectedLabels: true,
    showUnselectedLabels: true,
  ),
);
