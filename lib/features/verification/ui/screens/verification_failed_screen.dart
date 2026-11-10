import 'package:flutter/material.dart';

import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/features/verification/ui/widgets/verification_parts.dart';

class VerificationFailedScreen extends StatelessWidget {
  const VerificationFailedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final outcome =
        ModalRoute.of(context)!.settings.arguments! as VerificationOutcome;
    final post = outcome.post;
    final result = outcome.result;
    final canRetry = result.attemptsLeft > 0;

    return ResultBody(
      hero: const FdResultHero(
        mood: FdMood.triste,
        tag: 'No coincide',
        isProblem: true,
      ),
      actions: [
        if (canRetry)
          FdButton(
            label: 'Intentar de nuevo',
            onPressed: () => Navigator.pushReplacementNamed(
              context,
              AppRoutes.verificationQuestion,
              arguments: post.id,
            ),
          ),
        FdButton(
          label: 'Volver al inicio',
          variant: canRetry ? FdButtonVariant.ghost : FdButtonVariant.primary,
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.main,
            (_) => false,
          ),
        ),
      ],
      children: [
        Text('Algunas respuestas no coinciden', style: FdTypography.h1),
        const SizedBox(height: FdSpacing.xs),
        Text(
          'Lo que respondiste no coincide con la información que dejó ${post.firstName}.',
          style: FdTypography.body.copyWith(color: FdColors.textSecondary),
        ),
        const SizedBox(height: FdSpacing.lg),
        FdGlass(
          strong: true,
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (var i = 0; i < result.results.length; i++)
                ListTile(
                  title: Text(
                    i < outcome.questions.length
                        ? outcome.questions[i].text
                        : 'Pregunta ${i + 1}',
                    style: FdTypography.bodyStrong,
                  ),
                  trailing: result.results[i]
                      ? const FdBadge(
                          label: 'Correcta',
                          color: FdColors.success,
                          background: FdColors.primarySoft,
                        )
                      : const FdBadge(
                          label: 'Incorrecta',
                          color: FdColors.lost,
                          background: FdColors.lostSoft,
                        ),
                ),
            ],
          ),
        ),
        const SizedBox(height: FdSpacing.md),
        FdInfoNote(
          icon: Icons.lock_outline_rounded,
          message: canRetry
              ? 'Te queda ${result.attemptsLeft == 1 ? 'un intento' : '${result.attemptsLeft} intentos'}. Por seguridad no mostramos la respuesta correcta.'
              : 'Ya no te quedan intentos para esta publicación.',
        ),
      ],
    );
  }
}
