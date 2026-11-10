import 'package:flutter/material.dart';

import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/core/utils/formatters.dart';
import 'package:findu/features/chat/domain/chat_models.dart';
import 'package:findu/features/posts/ui/widgets/post_loader.dart';

class DeliveryVerifiedScreen extends StatelessWidget {
  const DeliveryVerifiedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final conversation =
        ModalRoute.of(context)!.settings.arguments! as Conversation;
    final post = conversation.post;
    final iFoundIt = conversation.iFoundIt;
    final article = post.feminine ? 'la' : 'el';
    final name = post.isPet
        ? 'a ${post.title}'
        : (iFoundIt
              ? '$article ${post.title.toLowerCase()}'
              : 'tu ${post.title.toLowerCase()}');
    final title = iFoundIt ? '¡Entregaste $name!' : '¡Recibiste $name!';
    final message = iFoundIt
        ? (post.reward != null
              ? 'Los dos confirmaron la entrega. La recompensa de ${formatCop(post.reward!)} quedó liberada para ti.'
              : 'Los dos confirmaron la entrega. Gracias por ayudar a tu comunidad.')
        : 'Los dos confirmaron la entrega. La publicación quedó cerrada.';

    return Scaffold(
      backgroundColor: FdColors.background,
      body: Column(
        children: [
          const FdResultHero(mood: FdMood.feliz, tag: 'Entrega verificada'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(FdSpacing.screen),
              children: [
                Text(title, style: FdTypography.h1),
                const SizedBox(height: FdSpacing.xs),
                Text(
                  message,
                  style: FdTypography.body.copyWith(
                    color: FdColors.textSecondary,
                  ),
                ),
                const SizedBox(height: FdSpacing.lg),
                FdListRow(
                  leading: PostThumb(post: post),
                  title: post.title,
                  subtitle:
                      '${iFoundIt ? 'Entregado a' : 'Entregado por'} ${conversation.otherName}',
                  trailing: FdBadge.status(FdStatus.verified),
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
              child: FdButton(
                label: 'Volver al inicio',
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.main,
                  (_) => false,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
