import 'package:flutter/material.dart';

import 'package:findu/core/demo/demo_data.dart';
import 'package:findu/core/demo/demo_visuals.dart';
import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_routes.dart';

class ProblemSentScreen extends StatelessWidget {
  const ProblemSentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final post = DemoData.post(routeId(context));

    return Scaffold(
      backgroundColor: FdColors.background,
      body: Column(
        children: [
          const FdResultHero(mood: FdMood.triste, tag: 'Entrega no completada', isProblem: true),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(FdSpacing.screen),
              children: [
                Text('Reporte enviado', style: FdTypography.h1),
                const SizedBox(height: FdSpacing.xs),
                Text(
                  'Lo revisaremos. Mientras tanto pueden seguir hablando por el chat para intentarlo otra vez.',
                  style: FdTypography.body.copyWith(color: FdColors.textSecondary),
                ),
                const SizedBox(height: FdSpacing.lg),
                FdListRow(
                  leading: Icon(post.icon, color: FdColors.primary, size: 32),
                  title: post.title,
                  subtitle: post.reward == null
                      ? 'Sigue ${post.feminine ? 'publicada' : 'publicado'}'
                      : 'Sigue ${post.feminine ? 'publicada' : 'publicado'} · Recompensa retenida',
                  trailing: FdBadge.status(FdStatus.problem),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(FdSpacing.screen, 0, FdSpacing.screen, FdSpacing.md),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FdButton(label: 'Volver al chat', onPressed: () => Navigator.pop(context)),
                  FdButton(
                    label: 'Volver al inicio',
                    variant: FdButtonVariant.ghost,
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(context, AppRoutes.main, (_) => false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
