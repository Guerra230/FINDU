import 'package:flutter/material.dart';

import 'package:findu/core/design_system/components/fd_glass.dart';
import 'package:findu/core/design_system/tokens/fd_colors.dart';
import 'package:findu/core/design_system/tokens/fd_radius.dart';
import 'package:findu/core/design_system/tokens/fd_spacing.dart';
import 'package:findu/core/design_system/tokens/fd_typography.dart';

class FdAvatar extends StatelessWidget {
  const FdAvatar({super.key, required this.name, this.size = 44, this.image});

  final String name;
  final double size;
  final ImageProvider? image;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    return parts.take(2).map((p) => p[0].toUpperCase()).join();
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: FdColors.primarySoft,
      backgroundImage: image,
      child: image == null
          ? Text(initials, style: FdTypography.bodyStrong.copyWith(color: FdColors.primary, fontSize: size * 0.34))
          : null,
    );
  }
}

class FdSteps extends StatelessWidget {
  const FdSteps({super.key, required this.current, this.total = 3});

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Paso $current de $total',
      child: Row(
        children: [
          for (var i = 1; i <= total; i++) ...[
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 6,
                decoration: BoxDecoration(
                  color: i <= current ? FdColors.primary : FdColors.border,
                  borderRadius: BorderRadius.circular(FdRadius.pill),
                ),
              ),
            ),
            if (i < total) const SizedBox(width: FdSpacing.xs),
          ],
        ],
      ),
    );
  }
}

class FdToggleRow extends StatelessWidget {
  const FdToggleRow({super.key, required this.label, required this.value, required this.onChanged});

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: FdSpacing.md),
        title: Text(label, style: FdTypography.bodyStrong),
        trailing: Switch(value: value, onChanged: onChanged),
        onTap: () => onChanged(!value),
      ),
    );
  }
}

class FdInfoNote extends StatelessWidget {
  const FdInfoNote({super.key, required this.message, this.icon = Icons.info_outline_rounded});

  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(FdSpacing.md),
      decoration: BoxDecoration(
        color: FdColors.primarySoft,
        borderRadius: BorderRadius.circular(FdRadius.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: FdColors.primary, size: 20),
          const SizedBox(width: FdSpacing.sm),
          Expanded(child: Text(message, style: FdTypography.caption.copyWith(color: FdColors.primaryDark))),
        ],
      ),
    );
  }
}

class FdListRow extends StatelessWidget {
  const FdListRow({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return FdGlass(
      strong: true,
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: FdSpacing.md, vertical: FdSpacing.sm),
      child: Row(
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: FdSpacing.sm)],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: FdTypography.bodyStrong),
                if (subtitle != null) Text(subtitle!, style: FdTypography.caption),
              ],
            ),
          ),
          trailing ?? (onTap != null ? const Icon(Icons.chevron_right_rounded, color: FdColors.primary) : const SizedBox.shrink()),
        ],
      ),
    );
  }
}
