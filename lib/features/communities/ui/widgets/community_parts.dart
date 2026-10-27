import 'package:flutter/material.dart';

import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_routes.dart';

void goToCommunities(BuildContext context) {
  Navigator.pushNamedAndRemoveUntil(
    context,
    AppRoutes.communities,
    (route) => route.settings.name == AppRoutes.main || route.isFirst,
  );
}

class StatusTimeline extends StatelessWidget {
  const StatusTimeline({super.key, required this.steps, required this.current});

  final List<String> steps;
  final int current;

  @override
  Widget build(BuildContext context) {
    return FdGlass(
      strong: true,
      child: Column(
        children: [
          for (var i = 0; i < steps.length; i++) ...[
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i <= current ? FdColors.primary : FdColors.background,
                    border: Border.all(color: i <= current ? FdColors.primary : FdColors.border),
                  ),
                  child: Icon(
                    i < current ? Icons.check_rounded : (i == current ? Icons.more_horiz_rounded : Icons.circle_outlined),
                    size: 16,
                    color: i <= current ? FdColors.onPrimary : FdColors.textDisabled,
                  ),
                ),
                const SizedBox(width: FdSpacing.sm),
                Expanded(
                  child: Text(
                    steps[i],
                    style: i <= current ? FdTypography.bodyStrong : FdTypography.body.copyWith(color: FdColors.textSecondary),
                  ),
                ),
              ],
            ),
            if (i < steps.length - 1)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: FdSpacing.xs),
                child: Divider(),
              ),
          ],
        ],
      ),
    );
  }
}

class RoleChip extends StatelessWidget {
  const RoleChip({super.key, required this.label, this.highlighted = false});

  final String label;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: FdSpacing.sm, vertical: FdSpacing.xxs),
      decoration: BoxDecoration(
        color: highlighted ? FdColors.primary : FdColors.primarySoft,
        borderRadius: BorderRadius.circular(FdRadius.pill),
      ),
      child: Text(
        label,
        style: FdTypography.label.copyWith(
          color: highlighted ? FdColors.onPrimary : FdColors.primaryDark,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
