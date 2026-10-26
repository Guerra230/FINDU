import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:findu/core/design_system/tokens/fd_colors.dart';

abstract final class FdTypography {
  static TextStyle get display => GoogleFonts.fraunces(
        fontSize: 34,
        fontWeight: FontWeight.w600,
        height: 1.1,
        letterSpacing: -0.4,
        color: FdColors.textPrimary,
      );

  static TextStyle get h1 => GoogleFonts.fraunces(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.15,
        letterSpacing: -0.3,
        color: FdColors.textPrimary,
      );

  static TextStyle get h2 => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.25,
        color: FdColors.textPrimary,
      );

  static TextStyle get title => GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: FdColors.textPrimary,
      );

  static TextStyle get bodyStrong => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        height: 1.35,
        color: FdColors.textPrimary,
      );

  static TextStyle get body => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: FdColors.textPrimary,
      );

  static TextStyle get button => GoogleFonts.inter(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: FdColors.onPrimary,
      );

  static TextStyle get label => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: FdColors.textSecondary,
      );

  static TextStyle get caption => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.35,
        color: FdColors.textSecondary,
      );

  static TextStyle get overline => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: FdColors.primaryDark,
      );
}
