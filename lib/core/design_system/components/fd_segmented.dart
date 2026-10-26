import 'package:flutter/material.dart';

import 'package:findu/core/design_system/components/fd_glass.dart';
import 'package:findu/core/design_system/tokens/fd_colors.dart';
import 'package:findu/core/design_system/tokens/fd_gradients.dart';
import 'package:findu/core/design_system/tokens/fd_radius.dart';
import 'package:findu/core/design_system/tokens/fd_typography.dart';

class FdSegmented<T> extends StatelessWidget {
  const FdSegmented({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  final Map<T, String> options;
  final T selected;
  final ValueChanged<T> onChanged;

  static const double height = 56;

  @override
  Widget build(BuildContext context) {
    return FdGlass(
      radius: FdRadius.pill,
      padding: const EdgeInsets.all(4),
      child: SizedBox(
        height: height - 8,
        child: Row(
          children: [
            for (final entry in options.entries)
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onChanged(entry.key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(FdRadius.pill),
                      gradient: entry.key == selected ? FdGradients.button : null,
                    ),
                    child: Text(
                      entry.value,
                      style: FdTypography.bodyStrong.copyWith(
                        color: entry.key == selected ? FdColors.onPrimary : FdColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
