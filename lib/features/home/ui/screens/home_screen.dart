import 'package:flutter/material.dart';

import 'package:findu/core/demo/demo_data.dart';
import 'package:findu/core/demo/demo_visuals.dart';
import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/core/navigation/main_shell.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PostKind? _kind;

  @override
  Widget build(BuildContext context) {
    final unread = DemoData.notifications.where((n) => n.unread).length;
    final recent = DemoData.posts.where((p) => _kind == null || p.kind == _kind).take(6).toList();

    return FdBackground(
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 120),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(FdSpacing.screen, FdSpacing.md, FdSpacing.screen, 0),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined, color: FdColors.primary),
                  const SizedBox(width: FdSpacing.xxs),
                  Expanded(child: Text('Cali, Valle del Lili', style: FdTypography.bodyStrong)),
                  FdIconButton(
                    icon: Icons.notifications_none_rounded,
                    tooltip: 'Notificaciones',
                    badgeCount: unread,
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.notifications),
                  ),
                ],
              ),
            ),
            const FdLargeTitle(title: '¿Perdiste algo?', subtitle: 'Encuéntralo'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: FdSpacing.screen),
              child: FdGlass(
                strong: true,
                radius: FdRadius.pill,
                onTap: () => MainShell.goTo(context, AppTabs.explore),
                padding: const EdgeInsets.fromLTRB(FdSpacing.md, FdSpacing.xs, FdSpacing.xs, FdSpacing.xs),
                child: Row(
                  children: [
                    const Icon(Icons.search_rounded, color: FdColors.textSecondary),
                    const SizedBox(width: FdSpacing.xs),
                    Expanded(
                      child: Text(
                        'Busca objetos o mascotas…',
                        style: FdTypography.body.copyWith(color: FdColors.textDisabled),
                      ),
                    ),
                    FdIconButton(
                      icon: Icons.tune_rounded,
                      filled: true,
                      tooltip: 'Filtros',
                      onPressed: () => MainShell.goTo(context, AppTabs.explore),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: FdSpacing.md),
            FdChipBar<PostKind?>(
              options: const {null: 'Todo', PostKind.object: 'Objetos', PostKind.pet: 'Mascotas'},
              selected: _kind,
              onChanged: (v) => setState(() => _kind = v),
            ),
            FdSectionHeader(
              title: 'Recientes',
              actionLabel: 'ver todo',
              onAction: () => MainShell.goTo(context, AppTabs.explore),
            ),
            SizedBox(
              height: 330,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: FdSpacing.screen),
                itemCount: recent.length,
                separatorBuilder: (_, _) => const SizedBox(width: FdSpacing.md),
                itemBuilder: (context, index) {
                  final post = recent[index];
                  return FdPostCard(
                    title: post.title,
                    subtitle: post.placeAgo,
                    status: post.status,
                    feminine: post.feminine,
                    icon: post.icon,
                    width: 250,
                    height: 320,
                    onTap: () => Navigator.pushNamed(context, AppRoutes.postDetail, arguments: post.id),
                    onMap: () => Navigator.pushNamed(context, AppRoutes.map, arguments: post.id),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
