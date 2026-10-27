import 'package:flutter/material.dart';

import 'package:findu/core/demo/demo_data.dart';
import 'package:findu/core/demo/demo_visuals.dart';
import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/features/verification/ui/widgets/verification_parts.dart';

class VerificationFailedScreen extends StatelessWidget {
  const VerificationFailedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final post = DemoData.post(routeId(context));
    final results = [true, false, true];

    return ResultBody(
      hero: const FdResultHero(mood: FdMood.triste, tag: 'No coincide', isProblem: true),
      actions: [
        FdButton(
          label: 'Intentar de nuevo',
          onPressed: () => Navigator.pushReplacementNamed(
            context,
            AppRoutes.verificationQuestion,
            arguments: VerificationArgs(postId: post.id, index: 0),
          ),
        ),
        FdButton(
          label: 'Volver al inicio',
          variant: FdButtonVariant.ghost,
          onPressed: () => Navigator.pushNamedAndRemoveUntil(context, AppRoutes.main, (_) => false),
        ),
      ],
      children: [
        Text('Algunas respuestas no coinciden', style: FdTypography.h1),
        const SizedBox(height: FdSpacing.xs),
        Text(
          'Lo que respondiste no coincide con la información que dejó ${post.author}. Puedes intentarlo una vez más.',
          style: FdTypography.body.copyWith(color: FdColors.textSecondary),
        ),
        const SizedBox(height: FdSpacing.lg),
        FdGlass(
          strong: true,
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (var i = 0; i < results.length; i++)
                ListTile(
                  title: Text(
                    post.questions.length > i ? post.questions[i] : 'Pregunta ${i + 1}',
                    style: FdTypography.bodyStrong,
                  ),
                  trailing: results[i]
                      ? const FdBadge(label: 'Correcta', color: FdColors.success, background: FdColors.primarySoft)
                      : const FdBadge(label: 'Incorrecta', color: FdColors.lost, background: FdColors.lostSoft),
                ),
            ],
          ),
        ),
        const SizedBox(height: FdSpacing.md),
        const FdInfoNote(
          icon: Icons.lock_outline_rounded,
          message: 'Te queda un intento. Por seguridad no mostramos la respuesta correcta.',
        ),
      ],
    );
  }
}
