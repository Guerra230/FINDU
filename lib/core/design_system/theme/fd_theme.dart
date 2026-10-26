import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:findu/core/design_system/tokens/fd_colors.dart';
import 'package:findu/core/design_system/tokens/fd_radius.dart';

abstract final class FdTheme {
  static ThemeData get light {
    final baseText = ThemeData(brightness: Brightness.light).textTheme;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: FdColors.primary,
        onPrimary: FdColors.onPrimary,
        secondary: FdColors.primaryLight,
        onSecondary: FdColors.onPrimary,
        surface: FdColors.surface,
        onSurface: FdColors.textPrimary,
        error: FdColors.lost,
        onError: FdColors.onPrimary,
        outline: FdColors.border,
      ),
      scaffoldBackgroundColor: FdColors.background,
      canvasColor: FdColors.background,
      splashFactory: InkSparkle.splashFactory,
      textTheme: GoogleFonts.interTextTheme(baseText).apply(
        bodyColor: FdColors.textPrimary,
        displayColor: FdColors.textPrimary,
      ),
      dividerTheme: const DividerThemeData(color: FdColors.border, thickness: 1, space: 1),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all(FdColors.onPrimary),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? FdColors.primary : FdColors.border,
        ),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(FdRadius.sheet)),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: FdColors.textPrimary,
      ),
    );
  }
}
