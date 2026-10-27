import 'package:flutter/material.dart';

import 'package:findu/core/demo/demo_data.dart';
import 'package:findu/core/demo/demo_visuals.dart';
import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_routes.dart';

class PostDetailScreen extends StatelessWidget {
  const PostDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final post = DemoData.post(routeId(context));
    final isFoundByOther = post.intent == PostIntent.found && !post.isMine;
    final isLostByOther = post.intent == PostIntent.lost && !post.isMine;

    final String actionLabel;
    final VoidCallback onAction;
    if (post.isMine) {
      actionLabel = 'Impulsar publicación';
      onAction = () => Navigator.pushNamed(context, AppRoutes.boost, arguments: post.id);
    } else if (isFoundByOther) {
      actionLabel = 'Es ${post.feminine ? 'mía' : 'mío'}';
      onAction = () => Navigator.pushNamed(context, AppRoutes.verificationIntro, arguments: post.id);
    } else {
      actionLabel = post.feminine ? 'La encontré' : 'Lo encontré';
      onAction = () => Navigator.pushNamed(context, AppRoutes.foundReport, arguments: post.id);
    }

    return Scaffold(
      backgroundColor: FdColors.background,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 320,
                      decoration: const BoxDecoration(gradient: FdGradients.hero),
                      alignment: Alignment.center,
                      child: Icon(post.icon, size: 120, color: FdColors.onPrimary.withValues(alpha: 0.85)),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: FdSpacing.md, vertical: FdSpacing.md),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FdIconButton(
                              icon: Icons.chevron_left_rounded,
                              tooltip: 'Atrás',
                              onPressed: () => Navigator.maybePop(context),
                            ),
                            FdIconButton(
                              icon: Icons.ios_share_rounded,
                              tooltip: 'Compartir',
                              onPressed: () => Navigator.pushNamed(context, AppRoutes.shareReport, arguments: post.id),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(FdSpacing.screen),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(post.title, style: FdTypography.h1),
                                Text(post.category, style: FdTypography.caption),
                              ],
                            ),
                          ),
                          FdBadge.status(post.status, feminine: post.feminine),
                        ],
                      ),
                      const SizedBox(height: FdSpacing.md),
                      Row(
                        children: [
                          Expanded(child: _InfoCell(label: post.isPet ? 'Especie' : 'Categoría', value: post.category)),
                          const SizedBox(width: FdSpacing.sm),
                          Expanded(
                            child: _InfoCell(
                              label: post.reward != null ? 'Recompensa' : 'Publicado',
                              value: post.reward != null ? formatCop(post.reward!) : post.ago,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: FdSpacing.sm),
                      FdGlass(
                        strong: true,
                        onTap: () => Navigator.pushNamed(context, AppRoutes.map, arguments: post.id),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on_outlined, color: FdColors.primary),
                            const SizedBox(width: FdSpacing.sm),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Última vez visto', style: FdTypography.label),
                                  Text('${post.place} · ${post.ago}', style: FdTypography.bodyStrong),
                                ],
                              ),
                            ),
                            Text('Ver mapa', style: FdTypography.bodyStrong.copyWith(color: FdColors.primary)),
                          ],
                        ),
                      ),
                      const SizedBox(height: FdSpacing.sm),
                      FdListRow(
                        leading: FdAvatar(name: post.author),
                        title: post.author,
                        subtitle: 'Publicado ${post.ago}',
                      ),
                      if (isFoundByOther) ...[
                        const SizedBox(height: FdSpacing.md),
                        const FdInfoNote(
                          icon: Icons.lock_outline_rounded,
                          message: 'Para hablar con quien lo encontró debes responder 3 preguntas privadas. Tienes 2 intentos.',
                        ),
                      ],
                      if (isLostByOther) ...[
                        const SizedBox(height: FdSpacing.md),
                        const FdInfoNote(
                          message: 'Si lo encontraste, envía fotos y se abre el chat con el dueño. La recompensa se libera al confirmar la entrega.',
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(FdSpacing.screen, 0, FdSpacing.screen, FdSpacing.md),
            child: SafeArea(top: false, child: FdButton(label: actionLabel, icon: Icons.chat_bubble_outline_rounded, onPressed: onAction)),
          ),
        ],
      ),
    );
  }
}

class _InfoCell extends StatelessWidget {
  const _InfoCell({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return FdGlass(
      strong: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: FdTypography.label),
          const SizedBox(height: FdSpacing.xxs),
          Text(value, style: FdTypography.h2),
        ],
      ),
    );
  }
}
