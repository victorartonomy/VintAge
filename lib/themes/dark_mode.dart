import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  colorScheme: const ColorScheme.dark(
    // very dark - app bar + drawer color
    surface: Color.fromARGB(255, 9, 9, 9),

    // slightly light
    primary: Color.fromARGB(255, 105, 105, 105),

    // dark
    secondary: Color.fromARGB(255, 20, 20, 20),

    // slightly dark
    tertiary: Color.fromARGB(255, 29, 29, 29),

    // very light
    inversePrimary: Color.fromARGB(255, 195, 195, 195),
  ),
  scaffoldBackgroundColor: Color.from(alpha: 255, red: 9, green: 9, blue: 9),
);
