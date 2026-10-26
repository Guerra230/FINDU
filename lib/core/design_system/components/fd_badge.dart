import 'package:flutter/material.dart';

import 'package:findu/core/design_system/tokens/fd_colors.dart';
import 'package:findu/core/design_system/tokens/fd_radius.dart';
import 'package:findu/core/design_system/tokens/fd_typography.dart';

enum FdStatus { lost, found, verified, pending, problem }

class FdBadge extends StatelessWidget {
  const FdBadge({super.key, required this.label, required this.color, required this.background});

  factory FdBadge.status(FdStatus status, {bool feminine = false}) {
    return switch (status) {
      FdStatus.lost => FdBadge(label: feminine ? 'Perdida' : 'Perdido', color: FdColors.lost, background: FdColors.lostSoft),
      FdStatus.found => FdBadge(label: feminine ? 'Encontrada' : 'Encontrado', color: FdColors.primaryDark, background: FdColors.foundSoft),
      FdStatus.verified => const FdBadge(label: 'Verificado', color: FdColors.primaryDark, background: FdColors.primarySoft),
      FdStatus.pending => const FdBadge(label: 'Pendiente', color: FdColors.textSecondary, background: FdColors.background),
      FdStatus.problem => const FdBadge(label: 'Con problema', color: FdColors.warning, background: FdColors.warningSoft),
    };
  }

  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: background.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(FdRadius.pill),
        border: Border.all(color: FdColors.glassBorder),
      ),
      child: Text(label, style: FdTypography.label.copyWith(color: color, fontWeight: FontWeight.w600, fontSize: 13)),
    );
  }
}
