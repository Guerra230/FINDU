import 'package:flutter/material.dart';

import 'package:findu/core/design_system/tokens/fd_colors.dart';
import 'package:findu/core/design_system/tokens/fd_effects.dart';

class FdIconButton extends StatelessWidget {
  const FdIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.badgeCount,
    this.filled = false,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final int? badgeCount;
  final bool filled;

  static const double size = 44;

  @override
  Widget build(BuildContext context) {
    final button = Material(
      color: filled ? FdColors.primary : FdColors.glassStrong,
      shape: const CircleBorder(side: BorderSide(color: FdColors.glassBorder)),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox.square(
          dimension: size,
          child: Icon(icon, size: 22, color: filled ? FdColors.onPrimary : FdColors.textPrimary),
        ),
      ),
    );

    final content = Stack(
        clipBehavior: Clip.none,
        children: [
          DecoratedBox(
            decoration: const BoxDecoration(shape: BoxShape.circle, boxShadow: FdEffects.softShadow),
            child: button,
          ),
          if (badgeCount != null && badgeCount! > 0)
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                decoration: const BoxDecoration(color: FdColors.primary, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Text(
                  '$badgeCount',
                  style: const TextStyle(color: FdColors.onPrimary, fontSize: 11, fontWeight: FontWeight.w700),
                ),
              ),
            ),
        ],
    );

    return tooltip == null ? content : Tooltip(message: tooltip!, child: content);
  }
}
