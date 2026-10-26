import 'package:flutter/material.dart';

import 'package:findu/core/design_system/components/fd_mascot.dart';
import 'package:findu/core/design_system/tokens/fd_colors.dart';
import 'package:findu/core/design_system/tokens/fd_gradients.dart';
import 'package:findu/core/design_system/tokens/fd_radius.dart';
import 'package:findu/core/design_system/tokens/fd_spacing.dart';
import 'package:findu/core/design_system/tokens/fd_typography.dart';

class FdResultHero extends StatelessWidget {
  const FdResultHero({
    super.key,
    required this.mood,
    required this.tag,
    this.isProblem = false,
    this.height = 300,
  });

  final FdMood mood;
  final String tag;
  final bool isProblem;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: isProblem ? FdGradients.problem : FdGradients.hero,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(FdRadius.xl)),
      ),
      child: Stack(
        children: [
          Center(
            child: Container(
              width: 176,
              height: 176,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.32),
                border: Border.all(color: Colors.white.withValues(alpha: 0.75), width: 1.5),
              ),
              alignment: Alignment.center,
              child: FdMascot(mood: mood, size: 140),
            ),
          ),
          Positioned(
            left: FdSpacing.screen,
            bottom: FdSpacing.md,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: FdSpacing.sm, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(FdRadius.pill),
                border: Border.all(color: FdColors.glassBorder),
              ),
              child: Text(tag.toUpperCase(), style: FdTypography.overline),
            ),
          ),
        ],
      ),
    );
  }
}
