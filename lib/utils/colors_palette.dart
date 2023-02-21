// Flutter imports:
import 'package:flutter/material.dart';

class ColorsPalette {
  static const _primaryColorValue = 0xFF2d6a4f;

  static const primarySwatch = MaterialColor(
    _primaryColorValue,
    {
      50: Color(0xFFe6edea),
      100: Color(0xFFc0d2ca),
      200: Color(0xFF96b5a7),
      300: Color(0xFF6c9784),
      400: Color(0xFF4d8069),
      500: Color(0xFF2d6a4f),
      600: Color(0xFF286248),
      700: Color(0xFF22573f),
      800: Color(0xFF1c4d36),
      900: Color(0xFF113c26),
    },
  );

  static const primaryColor = Color(_primaryColorValue);
  static const white = Colors.white;
  static const lightBackgroundColor = Color(0xFFdcded9);
  static const backgroundColor = Color(0xFFd2d7cb);
  static const darkBackgroundColor = Color(0xFFb3bf9c);

  // Greys
  static const grey = Color(0xFF968d9b);
  static const darkGrey = Color(0xFF707071);

  static const red = Color(0xFFea1010);
}
