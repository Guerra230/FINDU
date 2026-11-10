import 'package:flutter/material.dart';

import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/features/chat/domain/chat_models.dart';
import 'package:findu/features/posts/ui/widgets/post_loader.dart';

class ProblemSentScreen extends StatelessWidget {
  const ProblemSentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final conversation =
        ModalRoute.of(context)!.settings.arguments! as Conversation;
    final post = conversation.post;
    final published = post.feminine ? 'publicada' : 'publicado';

    return Scaffold(
      backgroundColor: FdColors.background,
      body: Column(
        children: [
          const FdResultHero(
            mood: FdMood.triste,
            tag: 'Entrega no completada',
            isProblem: true,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(FdSpacing.screen),
              children: [
                Text('Reporte enviado', style: FdTypography.h1),
                const SizedBox(height: FdSpacing.xs),
                Text(
                  'Lo revisaremos. Mientras tanto pueden seguir hablando por el chat para intentarlo otra vez.',
                  style: FdTypography.body.copyWith(
                    color: FdColors.textSecondary,
                  ),
                ),
                const SizedBox(height: FdSpacing.lg),
                FdListRow(
                  leading: PostThumb(post: post),
                  title: post.title,
                  subtitle: post.reward == null
                      ? 'Sigue $published'
                      : 'Sigue $published · Recompensa retenida',
                  trailing: FdBadge.status(FdStatus.problem),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              FdSpacing.screen,
              0,
              FdSpacing.screen,
              FdSpacing.md,
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FdButton(
                    label: 'Volver al chat',
                    onPressed: () => Navigator.pop(context),
                  ),
                  FdButton(
                    label: 'Volver al inicio',
                    variant: FdButtonVariant.ghost,
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.main,
                      (_) => false,
                    ),
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
