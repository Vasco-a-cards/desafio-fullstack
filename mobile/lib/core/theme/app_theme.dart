import 'package:flutter/material.dart';

const _seed = Color(0xFF0077B6); // deep ocean blue

const _lightScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF0077B6),
  onPrimary: Colors.white,
  primaryContainer: Color(0xFFCDE8F6),
  onPrimaryContainer: Color(0xFF003550),
  secondary: Color(0xFF00B4D8),
  onSecondary: Colors.white,
  secondaryContainer: Color(0xFFB9EEFF),
  onSecondaryContainer: Color(0xFF003544),
  tertiary: Color(0xFF48CAE4),
  onTertiary: Colors.white,
  tertiaryContainer: Color(0xFFD9F6FC),
  onTertiaryContainer: Color(0xFF00363F),
  error: Color(0xFFBA1A1A),
  onError: Colors.white,
  errorContainer: Color(0xFFFFDAD6),
  onErrorContainer: Color(0xFF410002),
  surface: Color(0xFFF8FBFF),
  onSurface: Color(0xFF191C1E),
  surfaceContainerHighest: Color(0xFFDDE3EA),
  onSurfaceVariant: Color(0xFF41484D),
  outline: Color(0xFF71787D),
  outlineVariant: Color(0xFFC1C7CE),
  shadow: Colors.black,
  scrim: Colors.black,
  inverseSurface: Color(0xFF2E3133),
  onInverseSurface: Color(0xFFEFF1F3),
  inversePrimary: Color(0xFF7FCFEF),
);

const _darkScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF7FCFEF),
  onPrimary: Color(0xFF003F5C),
  primaryContainer: Color(0xFF005880),
  onPrimaryContainer: Color(0xFFCDE8F6),
  secondary: Color(0xFF7CE8FF),
  onSecondary: Color(0xFF004E61),
  secondaryContainer: Color(0xFF006B85),
  onSecondaryContainer: Color(0xFFB9EEFF),
  tertiary: Color(0xFF80D4E8),
  onTertiary: Color(0xFF003740),
  tertiaryContainer: Color(0xFF004F5A),
  onTertiaryContainer: Color(0xFFD9F6FC),
  error: Color(0xFFFFB4AB),
  onError: Color(0xFF690005),
  errorContainer: Color(0xFF93000A),
  onErrorContainer: Color(0xFFFFDAD6),
  surface: Color(0xFF111416),
  onSurface: Color(0xFFE1E3E5),
  surfaceContainerHighest: Color(0xFF2E3133),
  onSurfaceVariant: Color(0xFFC1C7CE),
  outline: Color(0xFF8B9198),
  outlineVariant: Color(0xFF41484D),
  shadow: Colors.black,
  scrim: Colors.black,
  inverseSurface: Color(0xFFE1E3E5),
  onInverseSurface: Color(0xFF2E3133),
  inversePrimary: Color(0xFF0077B6),
);

TextTheme _buildTextTheme(ColorScheme cs) => TextTheme(
      displayLarge: TextStyle(
        fontSize: 57,
        fontWeight: FontWeight.w300,
        color: cs.onSurface,
        letterSpacing: -0.25,
      ),
      displayMedium: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.w300,
        color: cs.onSurface,
      ),
      displaySmall: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: cs.onSurface,
      ),
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: cs.onSurface,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: cs.onSurface,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: cs.onSurface,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: cs.onSurface,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: cs.onSurface,
        letterSpacing: 0.15,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: cs.onSurface,
        letterSpacing: 0.1,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: cs.onSurface,
        letterSpacing: 0.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: cs.onSurface,
        letterSpacing: 0.25,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: cs.onSurfaceVariant,
        letterSpacing: 0.4,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: cs.primary,
        letterSpacing: 0.1,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: cs.primary,
        letterSpacing: 0.5,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: cs.onSurfaceVariant,
        letterSpacing: 0.5,
      ),
    );

ThemeData _buildTheme(ColorScheme cs) => ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      textTheme: _buildTextTheme(cs),
      appBarTheme: AppBarTheme(
        backgroundColor: cs.surface,
        foregroundColor: cs.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: cs.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: cs.outlineVariant),
        ),
        color: cs.surface,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cs.surfaceContainerHighest.withValues(alpha: 0.4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: cs.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: cs.primary, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: BorderSide(color: cs.outlineVariant),
        backgroundColor: cs.surfaceContainerHighest.withValues(alpha: 0.5),
        labelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: cs.onSurfaceVariant,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: cs.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      scaffoldBackgroundColor: cs.surface,
    );

abstract final class AppTheme {
  static ThemeData get light => _buildTheme(_lightScheme);
  static ThemeData get dark => _buildTheme(_darkScheme);
}
