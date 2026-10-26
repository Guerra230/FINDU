import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:findu/core/design_system/components/fd_button.dart';
import 'package:findu/core/design_system/components/fd_mascot.dart';
import 'package:findu/core/design_system/tokens/fd_colors.dart';
import 'package:findu/core/design_system/tokens/fd_effects.dart';
import 'package:findu/core/design_system/tokens/fd_radius.dart';
import 'package:findu/core/design_system/tokens/fd_spacing.dart';
import 'package:findu/core/design_system/tokens/fd_typography.dart';

Future<T?> showFdBottomSheet<T>(BuildContext context, {required WidgetBuilder builder}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.35),
    builder: (context) => ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(FdRadius.sheet)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: FdEffects.glassBlur, sigmaY: FdEffects.glassBlur),
        child: Container(
          color: FdColors.glassStrong,
          padding: EdgeInsets.fromLTRB(
            FdSpacing.lg,
            FdSpacing.sm,
            FdSpacing.lg,
            FdSpacing.lg + MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(color: FdColors.border, borderRadius: BorderRadius.circular(3)),
                  ),
                ),
                const SizedBox(height: FdSpacing.md),
                builder(context),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class FdSheetContent extends StatelessWidget {
  const FdSheetContent({
    super.key,
    required this.title,
    this.message,
    this.mood,
    this.note,
    required this.primaryLabel,
    required this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
    this.secondaryIsDanger = false,
    this.cancelLabel = 'Cancelar',
  });

  final String title;
  final String? message;
  final FdMood? mood;
  final String? note;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final bool secondaryIsDanger;
  final String? cancelLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (mood != null) ...[
          Center(child: FdMascot(mood: mood!, size: 96)),
          const SizedBox(height: FdSpacing.sm),
        ],
        Text(title, style: FdTypography.h1),
        if (message != null) ...[
          const SizedBox(height: FdSpacing.xs),
          Text(message!, style: FdTypography.body.copyWith(color: FdColors.textSecondary)),
        ],
        if (note != null) ...[
          const SizedBox(height: FdSpacing.md),
          Container(
            padding: const EdgeInsets.all(FdSpacing.sm),
            decoration: BoxDecoration(
              color: FdColors.primarySoft,
              borderRadius: BorderRadius.circular(FdRadius.sm),
            ),
            child: Text(note!, style: FdTypography.caption.copyWith(color: FdColors.primaryDark)),
          ),
        ],
        const SizedBox(height: FdSpacing.lg),
        FdButton(label: primaryLabel, onPressed: onPrimary),
        if (secondaryLabel != null) ...[
          const SizedBox(height: FdSpacing.sm),
          FdButton(
            label: secondaryLabel!,
            onPressed: onSecondary,
            variant: secondaryIsDanger ? FdButtonVariant.danger : FdButtonVariant.secondary,
          ),
        ],
        if (cancelLabel != null)
          FdButton(
            label: cancelLabel!,
            variant: FdButtonVariant.ghost,
            onPressed: () => Navigator.pop(context),
          ),
      ],
    );
  }
}
