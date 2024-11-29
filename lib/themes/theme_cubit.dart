import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(ThemeDataStyle.light);

  void toggleTheme() {
    emit(state.brightness == Brightness.dark
        ? ThemeDataStyle.light
        : ThemeDataStyle.dark);
  }
}

class ThemeDataStyle {
  // Light Theme
  static ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(
      surface: Color(0xFFf5f5f5),
      primary: Color.fromRGBO(1, 5, 54, 1),
      secondary: Color(0xFFFFFF00),
      tertiary: Color(0xFFffd531),
      surfaceContainerHighest: Color.fromRGBO(1, 5, 54, 1),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromRGBO(128, 0, 0, 1),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Color.fromRGBO(200, 200, 200, 1),
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: Color(0xFF010536), // Dark blue color for text fields
      ),
      headlineMedium: TextStyle(
        color: Colors.black, // Black color for text fields
      ),
      headlineSmall: TextStyle(
        color: Colors.grey, // Grey color for text fields
      ),
      bodyLarge: TextStyle(
        color: Colors.white, // White color for text fields
      ),
    ),
  );

  // Dark Theme
  static ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF00204A), // Dark blue background
    colorScheme: ColorScheme.dark(
      surface: Colors.blue.shade900, // Darker surface color for dark mode
      primary: const Color(0xFF00204A), // Dark blue primary color
      secondary:
          Colors.blueAccent, // Accent color for buttons like Facebook/Google
      onPrimary: Colors.white, // Text color on primary elements
      onSecondary: Colors.black, // Text color on secondary elements
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: const Color(0xFFFFD700), // Bright yellow buttons
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.blueGrey.shade800, // Dark grey for input fields
      filled: true,
      hintStyle:
          const TextStyle(color: Colors.white54), // Placeholder text color
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white), // White text for dark mode
      bodyMedium: TextStyle(color: Colors.white70),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black, // Button text color
        backgroundColor: const Color(0xFFFFD700), // Bright yellow background
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Rounded button shape
        ),
      ),
    ),
  );
}
