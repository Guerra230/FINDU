import 'package:flutter/material.dart';

import 'package:findu/core/design_system/components/fd_button.dart';
import 'package:findu/core/design_system/components/fd_mascot.dart';
import 'package:findu/core/design_system/tokens/fd_colors.dart';
import 'package:findu/core/design_system/tokens/fd_spacing.dart';
import 'package:findu/core/design_system/tokens/fd_typography.dart';

class FdEmptyState extends StatelessWidget {
  const FdEmptyState({
    super.key,
    required this.title,
    required this.message,
    this.mood = FdMood.buscando,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String message;
  final FdMood mood;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(FdSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FdMascot(mood: mood, size: 120),
          const SizedBox(height: FdSpacing.lg),
          Text(title, textAlign: TextAlign.center, style: FdTypography.h1),
          const SizedBox(height: FdSpacing.xs),
          Text(message, textAlign: TextAlign.center, style: FdTypography.body.copyWith(color: FdColors.textSecondary)),
          if (actionLabel != null) ...[
            const SizedBox(height: FdSpacing.lg),
            FdButton(label: actionLabel!, onPressed: onAction, variant: FdButtonVariant.secondary),
          ],
        ],
      ),
    );
  }
}

class FdLoadingState extends StatelessWidget {
  const FdLoadingState({super.key, this.message = 'Cargando…'});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: FdColors.primary),
          const SizedBox(height: FdSpacing.md),
          Text(message, style: FdTypography.caption),
        ],
      ),
    );
  }
}

class FdErrorState extends StatelessWidget {
  const FdErrorState({super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return FdEmptyState(
      mood: FdMood.triste,
      title: 'Algo salió mal',
      message: message,
      actionLabel: 'Intentar de nuevo',
      onAction: onRetry,
    );
  }
}
