import 'package:flutter/material.dart';

import 'package:findu/core/design_system/components/fd_glass.dart';
import 'package:findu/core/design_system/tokens/fd_colors.dart';
import 'package:findu/core/design_system/tokens/fd_spacing.dart';
import 'package:findu/core/design_system/tokens/fd_typography.dart';

class FdOption<T> {
  const FdOption({required this.value, required this.title, this.subtitle, this.icon});

  final T value;
  final String title;
  final String? subtitle;
  final IconData? icon;
}

class FdOptionCards<T> extends StatelessWidget {
  const FdOptionCards({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  final List<FdOption<T>> options;
  final T? selected;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final option in options)
          Padding(
            padding: const EdgeInsets.only(bottom: FdSpacing.sm),
            child: FdGlass(
              strong: true,
              selected: option.value == selected,
              onTap: () => onChanged(option.value),
              child: Row(
                children: [
                  _Radio(selected: option.value == selected),
                  const SizedBox(width: FdSpacing.sm),
                  if (option.icon != null) ...[
                    Icon(option.icon, color: FdColors.primary),
                    const SizedBox(width: FdSpacing.sm),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(option.title, style: FdTypography.bodyStrong),
                        if (option.subtitle != null) Text(option.subtitle!, style: FdTypography.caption),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _Radio extends StatelessWidget {
  const _Radio({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: selected ? FdColors.primary : FdColors.textDisabled, width: 2),
      ),
      alignment: Alignment.center,
      child: selected
          ? Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: FdColors.primary),
            )
          : null,
    );
  }
}
