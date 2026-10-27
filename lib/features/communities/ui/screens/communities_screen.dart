import 'package:flutter/material.dart';

import 'package:findu/core/demo/demo_data.dart';
import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/features/communities/ui/widgets/community_parts.dart';

class CommunitiesScreen extends StatefulWidget {
  const CommunitiesScreen({super.key});

  @override
  State<CommunitiesScreen> createState() => _CommunitiesScreenState();
}

class _CommunitiesScreenState extends State<CommunitiesScreen> {
  String _active = DemoData.communities.first.name;

  @override
  Widget build(BuildContext context) {
    final admin = DemoData.communities.where((c) => c.isAdmin).toList();

    return FdScaffold(
      body: Column(
        children: [
          const FdScreenHeader(title: 'Mis comunidades'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(FdSpacing.screen, FdSpacing.xs, FdSpacing.screen, FdSpacing.lg),
              children: [
                Text('Toca una comunidad para cambiar la activa', style: FdTypography.caption),
                const SizedBox(height: FdSpacing.sm),
                for (final c in DemoData.communities)
                  Padding(
                    padding: const EdgeInsets.only(bottom: FdSpacing.sm),
                    child: FdGlass(
                      strong: true,
                      selected: c.name == _active,
                      onTap: () => setState(() => _active = c.name),
                      child: Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: const BoxDecoration(color: FdColors.primarySoft, shape: BoxShape.circle),
                            child: Icon(
                              c.type == 'Educativa' ? Icons.school_outlined : Icons.apartment_rounded,
                              color: FdColors.primary,
                            ),
                          ),
                          const SizedBox(width: FdSpacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(c.name, style: FdTypography.bodyStrong),
                                Text('${c.type} · ${c.members} miembros', style: FdTypography.caption),
                                const SizedBox(height: FdSpacing.xxs),
                                RoleChip(label: c.isAdmin ? 'Admin' : 'Miembro'),
                              ],
                            ),
                          ),
                          if (c.name == _active) const RoleChip(label: 'Activa', highlighted: true),
                        ],
                      ),
                    ),
                  ),
                if (admin.isNotEmpty) ...[
                  const SizedBox(height: FdSpacing.md),
                  Text('Tus paneles', style: FdTypography.h2),
                  const SizedBox(height: FdSpacing.sm),
                  for (final c in admin)
                    FdListRow(
                      leading: const Icon(Icons.admin_panel_settings_outlined, color: FdColors.primary),
                      title: 'Panel de administración',
                      subtitle: c.name,
                      onTap: () => Navigator.pushNamed(context, AppRoutes.adminPanel),
                    ),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(FdSpacing.screen, 0, FdSpacing.screen, FdSpacing.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FdButton(
                  label: 'Crear una comunidad',
                  variant: FdButtonVariant.secondary,
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.createCommunity),
                ),
                const SizedBox(height: FdSpacing.sm),
                FdButton(
                  label: 'Unirme a una comunidad',
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.joinCommunity),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
