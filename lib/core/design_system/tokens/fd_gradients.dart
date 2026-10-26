import 'package:flutter/material.dart';

import 'package:findu/core/design_system/tokens/fd_colors.dart';

abstract final class FdGradients {
  static const hero = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [FdColors.background, FdColors.primary],
  );

  static const heroInverse = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [FdColors.primary, Color(0xFF9FD6FF)],
  );

  static const problem = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [FdColors.warningSoft, FdColors.warning],
  );

  static const button = LinearGradient(
    colors: [FdColors.primaryLight, FdColors.primary],
  );

  static const mascot = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [FdColors.mascotTop, FdColors.mascotBottom],
  );
}
