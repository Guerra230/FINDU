import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:findu/core/design_system/tokens/fd_colors.dart';
import 'package:findu/core/design_system/tokens/fd_effects.dart';
import 'package:findu/core/design_system/tokens/fd_radius.dart';
import 'package:findu/core/design_system/tokens/fd_spacing.dart';

class FdGlass extends StatelessWidget {
  const FdGlass({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(FdSpacing.md),
    this.radius = FdRadius.md,
    this.strong = false,
    this.selected = false,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final bool strong;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final shape = BorderRadius.circular(radius);
    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: shape, boxShadow: FdEffects.softShadow),
      child: ClipRRect(
        borderRadius: shape,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: FdEffects.glassBlur, sigmaY: FdEffects.glassBlur),
          child: Material(
            color: selected
                ? FdColors.primarySoft
                : (strong ? FdColors.glassStrong : FdColors.glass),
            child: InkWell(
              onTap: onTap,
              child: Container(
                padding: padding,
                decoration: BoxDecoration(
                  borderRadius: shape,
                  border: Border.all(
                    color: selected ? FdColors.primary : FdColors.glassBorder,
                    width: selected ? 1.5 : 1,
                  ),
                ),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
