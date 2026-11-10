import 'package:flutter/material.dart';

import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/features/verification/ui/widgets/verification_parts.dart';

class VerificationApprovedScreen extends StatelessWidget {
  const VerificationApprovedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final outcome =
        ModalRoute.of(context)!.settings.arguments! as VerificationOutcome;
    final post = outcome.post;
    final conversationId = outcome.result.conversationId;

    return ResultBody(
      hero: const FdResultHero(
        mood: FdMood.feliz,
        tag: 'Verificación aprobada',
      ),
      actions: [
        if (conversationId != null)
          FdButton(
            label: 'Chatear con ${post.firstName}',
            icon: Icons.chat_bubble_outline_rounded,
            onPressed: () => Navigator.pushReplacementNamed(
              context,
              AppRoutes.chat,
              arguments: conversationId,
            ),
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
      children: [
        Text('¡Es ${post.feminine ? 'tuya' : 'tuyo'}!', style: FdTypography.h1),
        const SizedBox(height: FdSpacing.xs),
        Text(
          'Tus ${outcome.questions.length} respuestas coinciden. Ya puedes hablar con ${post.firstName} por el chat y acordar dónde verse.',
          style: FdTypography.body.copyWith(color: FdColors.textSecondary),
        ),
        const SizedBox(height: FdSpacing.lg),
        PostSummaryRow(post: post, trailing: FdBadge.status(FdStatus.verified)),
      ],
    );
  }
}
