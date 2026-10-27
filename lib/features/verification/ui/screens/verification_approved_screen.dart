import 'package:flutter/material.dart';

import 'package:findu/core/demo/demo_data.dart';
import 'package:findu/core/demo/demo_visuals.dart';
import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/features/verification/ui/widgets/verification_parts.dart';

class VerificationApprovedScreen extends StatelessWidget {
  const VerificationApprovedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final post = DemoData.post(routeId(context));

    return ResultBody(
      hero: const FdResultHero(mood: FdMood.feliz, tag: 'Verificación aprobada'),
      actions: [
        FdButton(
          label: 'Chatear con ${post.firstName}',
          icon: Icons.chat_bubble_outline_rounded,
          onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.chat, arguments: post.id),
        ),
        FdButton(
          label: 'Volver al inicio',
          variant: FdButtonVariant.ghost,
          onPressed: () => Navigator.pushNamedAndRemoveUntil(context, AppRoutes.main, (_) => false),
        ),
      ],
      children: [
        Text('¡Es ${post.feminine ? 'tuya' : 'tuyo'}!', style: FdTypography.h1),
        const SizedBox(height: FdSpacing.xs),
        Text(
          '${post.author} aprobó tus 3 respuestas. Ya pueden hablar por el chat y acordar dónde verse.',
          style: FdTypography.body.copyWith(color: FdColors.textSecondary),
        ),
        const SizedBox(height: FdSpacing.lg),
        PostSummaryRow(post: post, trailing: FdBadge.status(FdStatus.verified)),
      ],
    );
  }
}
