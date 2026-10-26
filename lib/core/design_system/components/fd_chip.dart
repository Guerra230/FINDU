import 'package:flutter/material.dart';

import 'package:findu/core/design_system/tokens/fd_colors.dart';
import 'package:findu/core/design_system/tokens/fd_radius.dart';
import 'package:findu/core/design_system/tokens/fd_spacing.dart';
import 'package:findu/core/design_system/tokens/fd_typography.dart';

class FdChip extends StatelessWidget {
  const FdChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
    this.leading,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? FdColors.primarySoft : FdColors.glassStrong,
      shape: StadiumBorder(
        side: BorderSide(color: selected ? FdColors.primary : FdColors.glassBorder, width: selected ? 1.5 : 1),
      ),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: FdSpacing.md),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leading != null) ...[leading!, const SizedBox(width: FdSpacing.xs)],
                if (icon != null) ...[
                  Icon(icon, size: 18, color: selected ? FdColors.primary : FdColors.textSecondary),
                  const SizedBox(width: FdSpacing.xs),
                ],
                Text(
                  label,
                  style: FdTypography.bodyStrong.copyWith(
                    color: selected ? FdColors.primaryDark : FdColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FdChipBar<T> extends StatelessWidget {
  const FdChipBar({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.padding = const EdgeInsets.symmetric(horizontal: FdSpacing.screen),
  });

  final Map<T, String> options;
  final T selected;
  final ValueChanged<T> onChanged;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: padding,
        itemCount: options.length,
        separatorBuilder: (_, _) => const SizedBox(width: FdSpacing.xs),
        itemBuilder: (context, index) {
          final entry = options.entries.elementAt(index);
          return Center(
            child: FdChip(
              label: entry.value,
              selected: entry.key == selected,
              onTap: () => onChanged(entry.key),
            ),
          );
        },
      ),
    );
  }
}

class FdTag extends StatelessWidget {
  const FdTag({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: FdSpacing.sm, vertical: 6),
      decoration: BoxDecoration(
        color: FdColors.glassStrong,
        borderRadius: BorderRadius.circular(FdRadius.pill),
        border: Border.all(color: FdColors.border),
      ),
      child: Text(label, style: FdTypography.caption.copyWith(color: FdColors.textPrimary)),
    );
  }
}
