import 'package:flutter/material.dart';

import 'package:findu/core/design_system/components/fd_glass.dart';
import 'package:findu/core/design_system/tokens/fd_colors.dart';
import 'package:findu/core/design_system/tokens/fd_effects.dart';
import 'package:findu/core/design_system/tokens/fd_gradients.dart';
import 'package:findu/core/design_system/tokens/fd_radius.dart';
import 'package:findu/core/design_system/tokens/fd_typography.dart';

enum FdButtonVariant { primary, secondary, danger, ghost }

class FdButton extends StatelessWidget {
  const FdButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = FdButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final FdButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !isLoading;
    final foreground = switch (variant) {
      FdButtonVariant.primary => FdColors.onPrimary,
      FdButtonVariant.secondary => FdColors.textPrimary,
      FdButtonVariant.danger => FdColors.lost,
      FdButtonVariant.ghost => FdColors.primary,
    };
    final height = switch (variant) {
      FdButtonVariant.primary => 60.0,
      FdButtonVariant.ghost => 44.0,
      _ => 52.0,
    };
    final textStyle = FdTypography.button.copyWith(
      color: foreground,
      fontSize: variant == FdButtonVariant.primary ? 18 : 16,
    );

    final content = isLoading
        ? SizedBox.square(
            dimension: 22,
            child: CircularProgressIndicator(strokeWidth: 2.4, color: foreground),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: foreground),
                const SizedBox(width: 8),
              ],
              Flexible(child: Text(label, overflow: TextOverflow.ellipsis, style: textStyle)),
            ],
          );

    final radius = BorderRadius.circular(FdRadius.pill);
    Widget button;
    switch (variant) {
      case FdButtonVariant.primary:
        button = DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: radius,
            gradient: FdGradients.button,
            boxShadow: enabled ? FdEffects.buttonShadow : null,
            border: Border.all(color: FdColors.glassBorder.withValues(alpha: 0.45)),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: radius,
            child: InkWell(
              borderRadius: radius,
              onTap: enabled ? onPressed : null,
              child: SizedBox(height: height, child: Center(child: content)),
            ),
          ),
        );
      case FdButtonVariant.secondary:
        button = FdGlass(
          radius: FdRadius.pill,
          strong: true,
          padding: EdgeInsets.zero,
          onTap: enabled ? onPressed : null,
          child: SizedBox(height: height, child: Center(child: content)),
        );
      case FdButtonVariant.danger:
        button = Material(
          color: FdColors.surface,
          shape: const StadiumBorder(side: BorderSide(color: FdColors.lost, width: 1.5)),
          child: InkWell(
            customBorder: const StadiumBorder(),
            onTap: enabled ? onPressed : null,
            child: SizedBox(height: height, child: Center(child: content)),
          ),
        );
      case FdButtonVariant.ghost:
        button = TextButton(
          onPressed: enabled ? onPressed : null,
          style: TextButton.styleFrom(minimumSize: Size(0, height), shape: const StadiumBorder()),
          child: content,
        );
    }

    return Semantics(
      button: true,
      enabled: enabled,
      child: Opacity(
        opacity: onPressed == null ? 0.5 : 1,
        child: expand ? SizedBox(width: double.infinity, child: button) : button,
      ),
    );
  }
}
