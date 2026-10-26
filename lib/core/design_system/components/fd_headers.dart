import 'package:flutter/material.dart';

import 'package:findu/core/design_system/components/fd_icon_button.dart';
import 'package:findu/core/design_system/tokens/fd_colors.dart';
import 'package:findu/core/design_system/tokens/fd_spacing.dart';
import 'package:findu/core/design_system/tokens/fd_typography.dart';

class FdScreenHeader extends StatelessWidget {
  const FdScreenHeader({
    super.key,
    required this.title,
    this.showBack = true,
    this.onBack,
    this.trailing,
  });

  final String title;
  final bool showBack;
  final VoidCallback? onBack;
  final Widget? trailing;

  static const double height = 76;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: FdSpacing.md),
        child: Row(
          children: [
            SizedBox(
              width: FdIconButton.size,
              child: showBack
                  ? FdIconButton(
                      icon: Icons.chevron_left_rounded,
                      tooltip: 'Atrás',
                      onPressed: onBack ?? () => Navigator.maybePop(context),
                    )
                  : null,
            ),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: FdTypography.title,
              ),
            ),
            SizedBox(width: FdIconButton.size, child: trailing),
          ],
        ),
      ),
    );
  }
}

class FdLargeTitle extends StatelessWidget {
  const FdLargeTitle({super.key, required this.title, this.subtitle, this.trailing});

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(FdSpacing.screen, FdSpacing.lg, FdSpacing.screen, FdSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: FdTypography.display),
                if (subtitle != null) ...[
                  const SizedBox(height: FdSpacing.xxs),
                  Text(subtitle!, style: FdTypography.display.copyWith(color: FdColors.textDisabled)),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class FdSectionHeader extends StatelessWidget {
  const FdSectionHeader({super.key, required this.title, this.actionLabel, this.onAction});

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(FdSpacing.screen, FdSpacing.lg, FdSpacing.screen, FdSpacing.sm),
      child: Row(
        children: [
          Expanded(child: Text(title, style: FdTypography.h2)),
          if (actionLabel != null)
            GestureDetector(
              onTap: onAction,
              child: Text(
                actionLabel!,
                style: FdTypography.label.copyWith(
                  color: FdColors.primary,
                  fontSize: 13,
                  decoration: TextDecoration.underline,
                  decorationColor: FdColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
