import 'package:flutter/material.dart';

import 'package:findu/core/demo/demo_data.dart';
import 'package:findu/core/demo/demo_visuals.dart';
import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const me = DemoData.me;
    final mine = DemoData.posts.where((p) => p.isMine).toList();
    final lost = mine.where((p) => p.intent == PostIntent.lost).length;

    return FdBackground(
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 120),
          children: [
            FdLargeTitle(
              title: 'Mi perfil',
              trailing: FdIconButton(
                icon: Icons.settings_outlined,
                tooltip: 'Configurar alertas',
                onPressed: () => Navigator.pushNamed(context, AppRoutes.alertSettings),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: FdSpacing.screen),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FdGlass(
                    strong: true,
                    radius: FdRadius.lg,
                    padding: const EdgeInsets.all(FdSpacing.lg),
                    child: Row(
                      children: [
                        FdAvatar(name: me.name, size: 72),
                        const SizedBox(width: FdSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(me.name, style: FdTypography.h2),
                              Text(me.program, style: FdTypography.caption),
                              const SizedBox(height: FdSpacing.xs),
                              if (me.university != null) FdTag(label: me.university!),
                            ],
                          ),
                        ),
                        const FdMascot(mood: FdMood.feliz, size: 64),
                      ],
                    ),
                  ),
                  const SizedBox(height: FdSpacing.sm),
                  Row(
                    children: [
                      const Expanded(child: _Stat(value: '4', label: 'Devueltos')),
                      const SizedBox(width: FdSpacing.sm),
                      Expanded(child: _Stat(value: '${mine.length}', label: 'Publicados')),
                      const SizedBox(width: FdSpacing.sm),
                      Expanded(child: _Stat(value: '$lost', label: 'Perdidos')),
                    ],
                  ),
                  const SizedBox(height: FdSpacing.lg),
                  Row(
                    children: [
                      Expanded(child: Text('Mis publicaciones', style: FdTypography.h2)),
                      Text('${mine.length} activas', style: FdTypography.caption),
                    ],
                  ),
                  const SizedBox(height: FdSpacing.sm),
                  for (final post in mine)
                    Padding(
                      padding: const EdgeInsets.only(bottom: FdSpacing.sm),
                      child: FdListRow(
                        leading: Icon(post.icon, color: FdColors.primary, size: 30),
                        title: post.title,
                        subtitle: '${post.place} · ${post.ago}',
                        trailing: FdBadge.status(post.status, feminine: post.feminine),
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.postDetail,
                          arguments: post.id,
                        ),
                      ),
                    ),
                  const SizedBox(height: FdSpacing.md),
                  FdListRow(
                    leading: const Icon(Icons.credit_card_rounded, color: FdColors.primary),
                    title: 'Métodos de pago',
                    onTap: () => Navigator.pushNamed(context, AppRoutes.paymentMethods),
                  ),
                  const SizedBox(height: FdSpacing.sm),
                  FdListRow(
                    leading: const Icon(Icons.groups_outlined, color: FdColors.primary),
                    title: 'Mis comunidades',
                    onTap: () => Navigator.pushNamed(context, AppRoutes.communities),
                  ),
                  const SizedBox(height: FdSpacing.sm),
                  FdListRow(
                    leading: const Icon(Icons.notifications_none_rounded, color: FdColors.primary),
                    title: 'Configurar alertas',
                    onTap: () => Navigator.pushNamed(context, AppRoutes.alertSettings),
                  ),
                  const SizedBox(height: FdSpacing.sm),
                  FdListRow(
                    leading: const Icon(Icons.logout_rounded, color: FdColors.lost),
                    title: 'Cerrar sesión',
                    onTap: () => Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return FdGlass(
      strong: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: FdTypography.h1.copyWith(color: FdColors.primary)),
          Text(label, style: FdTypography.caption),
        ],
      ),
    );
  }
}
