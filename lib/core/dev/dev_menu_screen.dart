import 'package:flutter/material.dart';

import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/core/navigation/screen_catalog.dart';

class DevMenuScreen extends StatelessWidget {
  const DevMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final groups = <String>[];
    for (final screen in screenCatalog) {
      if (!groups.contains(screen.group)) groups.add(screen.group);
    }

    return FdScaffold(
      body: Column(
        children: [
          const FdScreenHeader(title: 'Pantallas del Sprint 1'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(FdSpacing.screen, FdSpacing.xs, FdSpacing.screen, FdSpacing.xxl),
              children: [
                FdButton(
                  label: 'Ver el design system',
                  icon: Icons.palette_outlined,
                  variant: FdButtonVariant.secondary,
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.designSystem),
                ),
                for (final group in groups) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: FdSpacing.lg, bottom: FdSpacing.xs),
                    child: Text(group, style: FdTypography.h2),
                  ),
                  for (final screen in screenCatalog.where((s) => s.group == group))
                    Padding(
                      padding: const EdgeInsets.only(bottom: FdSpacing.xs),
                      child: FdListRow(
                        leading: SizedBox(
                          width: 56,
                          child: Text(screen.figma, style: FdTypography.bodyStrong.copyWith(color: FdColors.primary)),
                        ),
                        title: screen.title,
                        onTap: () => Navigator.pushNamed(context, screen.route, arguments: screen.tab),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
