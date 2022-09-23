import 'package:flutter/material.dart';


class AppColorTheme {
  //color 1 = Green, color 2 = red, color 3 = blue
  static ColorScheme getAppTheme(bool isDark, int color) {
    if(isDark){
      switch(color){
        case 1: return _darkColorSchemeGreen;
        case 2: return _darkColorSchemeRed;
        case 3: return _darkColorSchemeBlue;
        default: return _darkColorSchemeRed;
      }
    } else {
      switch(color){
        case 1: return _lightColorSchemeGreen;
        case 2: return _lightColorSchemeRed;
        case 3: return _lightColorSchemeBlue;
        default: return _lightColorSchemeRed;
      }
    }
  }

  static const green = Color(0xFF528e00);
  static const red = Color(0xFFd81629);
  static const blue = Color(0xFF004ff0);

  static const _lightColorSchemeGreen = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF3C6A00),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFB1F66A),
    onPrimaryContainer: Color(0xFF0E2000),
    secondary: Color(0xFF57624A),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFDBE7C8),
    onSecondaryContainer: Color(0xFF151E0B),
    tertiary: Color(0xFF386664),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFBBECE8),
    onTertiaryContainer: Color(0xFF00201F),
    error: Color(0xFFBA1A1A),
    errorContainer: Color(0xFFFFDAD6),
    onError: Color(0xFFFFFFFF),
    onErrorContainer: Color(0xFF410002),
    background: Color(0xFFFDFCF5),
    onBackground: Color(0xFF1B1C18),
    surface: Color(0xFFFDFCF5),
    onSurface: Color(0xFF1B1C18),
    surfaceVariant: Color(0xFFE1E4D5),
    onSurfaceVariant: Color(0xFF44483D),
    outline: Color(0xFF75796C),
    onInverseSurface: Color(0xFFF2F1EA),
    inverseSurface: Color(0xFF30312C),
    inversePrimary: Color(0xFF96D951),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFF3C6A00),
  );

  static const _darkColorSchemeGreen = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF96D951),
    onPrimary: Color(0xFF1D3700),
    primaryContainer: Color(0xFF2C5000),
    onPrimaryContainer: Color(0xFFB1F66A),
    secondary: Color(0xFFBFCBAD),
    onSecondary: Color(0xFF2A331F),
    secondaryContainer: Color(0xFF404A34),
    onSecondaryContainer: Color(0xFFDBE7C8),
    tertiary: Color(0xFFA0CFCC),
    onTertiary: Color(0xFF003735),
    tertiaryContainer: Color(0xFF1F4E4C),
    onTertiaryContainer: Color(0xFFBBECE8),
    error: Color(0xFFFFB4AB),
    errorContainer: Color(0xFF93000A),
    onError: Color(0xFF690005),
    onErrorContainer: Color(0xFFFFDAD6),
    background: Color(0xFF1B1C18),
    onBackground: Color(0xFFE3E3DB),
    surface: Color(0xFF1B1C18),
    onSurface: Color(0xFFE3E3DB),
    surfaceVariant: Color(0xFF44483D),
    onSurfaceVariant: Color(0xFFC4C8BA),
    outline: Color(0xFF8E9285),
    onInverseSurface: Color(0xFF1B1C18),
    inverseSurface: Color(0xFFE3E3DB),
    inversePrimary: Color(0xFF3C6A00),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFF96D951),
  );

  static const _lightColorSchemeRed = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFC0001E),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFFFDAD7),
    onPrimaryContainer: Color(0xFF410004),
    secondary: Color(0xFF775654),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFFFDAD7),
    onSecondaryContainer: Color(0xFF2C1514),
    tertiary: Color(0xFF735B2E),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFFFDEA7),
    onTertiaryContainer: Color(0xFF271900),
    error: Color(0xFFBA1A1A),
    errorContainer: Color(0xFFFFDAD6),
    onError: Color(0xFFFFFFFF),
    onErrorContainer: Color(0xFF410002),
    background: Color(0xFFFFFBFF),
    onBackground: Color(0xFF201A1A),
    surface: Color(0xFFFFFBFF),
    onSurface: Color(0xFF201A1A),
    surfaceVariant: Color(0xFFF5DDDB),
    onSurfaceVariant: Color(0xFF534342),
    outline: Color(0xFF857371),
    onInverseSurface: Color(0xFFFBEEEC),
    inverseSurface: Color(0xFF362F2E),
    inversePrimary: Color(0xFFFFB3AE),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFFC0001E),
  );

  static const _darkColorSchemeRed = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFFFB3AE),
    onPrimary: Color(0xFF68000B),
    primaryContainer: Color(0xFF930015),
    onPrimaryContainer: Color(0xFFFFDAD7),
    secondary: Color(0xFFE7BDB9),
    onSecondary: Color(0xFF442927),
    secondaryContainer: Color(0xFF5D3F3D),
    onSecondaryContainer: Color(0xFFFFDAD7),
    tertiary: Color(0xFFE2C28C),
    onTertiary: Color(0xFF402D04),
    tertiaryContainer: Color(0xFF594319),
    onTertiaryContainer: Color(0xFFFFDEA7),
    error: Color(0xFFFFB4AB),
    errorContainer: Color(0xFF93000A),
    onError: Color(0xFF690005),
    onErrorContainer: Color(0xFFFFDAD6),
    background: Color(0xFF201A1A),
    onBackground: Color(0xFFEDE0DE),
    surface: Color(0xFF201A1A),
    onSurface: Color(0xFFEDE0DE),
    surfaceVariant: Color(0xFF534342),
    onSurfaceVariant: Color(0xFFD8C2C0),
    outline: Color(0xFFA08C8B),
    onInverseSurface: Color(0xFF201A1A),
    inverseSurface: Color(0xFFEDE0DE),
    inversePrimary: Color(0xFFC0001E),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFFFFB3AE),
  );


  static const _lightColorSchemeBlue = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF004DEA),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFDCE1FF),
    onPrimaryContainer: Color(0xFF001551),
    secondary: Color(0xFF595D72),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFDEE1F9),
    onSecondaryContainer: Color(0xFF161B2C),
    tertiary: Color(0xFF75546F),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFFFD7F5),
    onTertiaryContainer: Color(0xFF2C1229),
    error: Color(0xFFBA1A1A),
    errorContainer: Color(0xFFFFDAD6),
    onError: Color(0xFFFFFFFF),
    onErrorContainer: Color(0xFF410002),
    background: Color(0xFFFEFBFF),
    onBackground: Color(0xFF1B1B1F),
    surface: Color(0xFFFEFBFF),
    onSurface: Color(0xFF1B1B1F),
    surfaceVariant: Color(0xFFE2E1EC),
    onSurfaceVariant: Color(0xFF45464F),
    outline: Color(0xFF767680),
    onInverseSurface: Color(0xFFF2F0F4),
    inverseSurface: Color(0xFF303034),
    inversePrimary: Color(0xFFB7C4FF),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFF004DEA),
  );

  static const _darkColorSchemeBlue = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFB7C4FF),
    onPrimary: Color(0xFF002681),
    primaryContainer: Color(0xFF0039B4),
    onPrimaryContainer: Color(0xFFDCE1FF),
    secondary: Color(0xFFC2C5DD),
    onSecondary: Color(0xFF2B3042),
    secondaryContainer: Color(0xFF424659),
    onSecondaryContainer: Color(0xFFDEE1F9),
    tertiary: Color(0xFFE3BADA),
    onTertiary: Color(0xFF43273F),
    tertiaryContainer: Color(0xFF5C3D57),
    onTertiaryContainer: Color(0xFFFFD7F5),
    error: Color(0xFFFFB4AB),
    errorContainer: Color(0xFF93000A),
    onError: Color(0xFF690005),
    onErrorContainer: Color(0xFFFFDAD6),
    background: Color(0xFF1B1B1F),
    onBackground: Color(0xFFE4E1E6),
    surface: Color(0xFF1B1B1F),
    onSurface: Color(0xFFE4E1E6),
    surfaceVariant: Color(0xFF45464F),
    onSurfaceVariant: Color(0xFFC6C5D0),
    outline: Color(0xFF90909A),
    onInverseSurface: Color(0xFF1B1B1F),
    inverseSurface: Color(0xFFE4E1E6),
    inversePrimary: Color(0xFF004DEA),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFFB7C4FF),
  );
}




