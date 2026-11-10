import 'package:flutter/material.dart';

import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/core/utils/formatters.dart';
import 'package:findu/features/posts/ui/widgets/post_loader.dart';
import 'package:findu/features/verification/ui/widgets/verification_parts.dart';

class VerificationIntroScreen extends StatelessWidget {
  const VerificationIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PostLoader(
      postId: routeId(context),
      builder: (context, post) => FdScaffold(
        body: Column(
          children: [
            const FdScreenHeader(title: 'Verificación'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(FdSpacing.screen),
                children: [
                  PostSummaryRow(post: post),
                  const SizedBox(height: FdSpacing.xl),
                  const Center(
                    child: FdMascot(mood: FdMood.buscando, size: 140),
                  ),
                  const SizedBox(height: FdSpacing.lg),
                  Text(
                    '¿${post.feminine ? 'Es tuya' : 'Es tuyo'}?',
                    style: FdTypography.h1,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: FdSpacing.xs),
                  Text(
                    'Para confirmarlo, responde las preguntas que dejó ${post.firstName}. No importan mayúsculas ni espacios.',
                    textAlign: TextAlign.center,
                    style: FdTypography.body.copyWith(
                      color: FdColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: FdSpacing.lg),
                  const FdInfoNote(
                    icon: Icons.lock_outline_rounded,
                    message:
                        'Tienes 2 intentos. Las respuestas solo las ve quien publica y no compartimos tu contacto.',
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
              child: FdButton(
                label: 'Empezar',
                onPressed: () => Navigator.pushNamed(
                  context,
                  AppRoutes.verificationQuestion,
                  arguments: post.id,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
