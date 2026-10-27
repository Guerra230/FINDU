import 'package:flutter/material.dart';

import 'package:findu/core/demo/demo_data.dart';
import 'package:findu/core/demo/demo_visuals.dart';
import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_routes.dart';

class DeliveryVerifiedScreen extends StatelessWidget {
  const DeliveryVerifiedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final post = DemoData.post(routeId(context));
    final iFoundIt = post.intent == PostIntent.lost;
    final article = post.feminine ? 'la' : 'el';
    final name = post.isPet ? 'a ${post.title}' : (iFoundIt ? '$article ${post.title.toLowerCase()}' : 'tu ${post.title.toLowerCase()}');
    final title = iFoundIt ? '¡Entregaste $name!' : '¡Recibiste $name!';
    final message = iFoundIt
        ? (post.reward != null
            ? 'Los dos confirmaron la entrega. La recompensa de ${formatCop(post.reward!)} ya está en tu cuenta.'
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
                Text(message, style: FdTypography.body.copyWith(color: FdColors.textSecondary)),
                const SizedBox(height: FdSpacing.lg),
                FdListRow(
                  leading: Icon(post.icon, color: FdColors.primary, size: 32),
                  title: post.title,
                  subtitle: '${iFoundIt ? 'Entregado a' : 'Entregado por'} ${post.author} · Punto acordado en el chat',
                  trailing: FdBadge.status(FdStatus.verified),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(FdSpacing.screen, 0, FdSpacing.screen, FdSpacing.md),
            child: SafeArea(
              top: false,
              child: FdButton(
                label: 'Volver al inicio',
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, AppRoutes.main, (_) => false),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
