import 'package:flutter/material.dart';

import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/features/publish/ui/widgets/publish_parts.dart';

class PublishedScreen extends StatelessWidget {
  const PublishedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final published = args is PublishedArgs ? args : null;
    final kind = published?.kind ?? PublishKinds.petLost;
    final isPet = kind == PublishKinds.petLost || kind == PublishKinds.petFound;
    final isLost =
        kind == PublishKinds.objectLost || kind == PublishKinds.petLost;

    final title = switch (kind) {
      PublishKinds.objectLost ||
      PublishKinds.objectFound => '¡Objeto publicado!',
      PublishKinds.petLost => '¡Reporte publicado!',
      _ => '¡Mascota reportada!',
    };
    final message = isLost
        ? 'Ya es visible para todos en FINDU. Te avisaremos cuando alguien lo encuentre.'
        : 'Solo quien responda bien tus preguntas privadas podrá contactarte.';

    return Scaffold(
      backgroundColor: FdColors.background,
      body: Column(
        children: [
          FdResultHero(
            mood: isLost && isPet ? FdMood.buscando : FdMood.feliz,
            tag: isLost ? 'Alerta enviada' : 'Protegido con preguntas',
          ),
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
                if (isLost)
                  FdButton(
                    label: 'Ver mi publicación',
                    variant: FdButtonVariant.secondary,
                    onPressed: () => Navigator.pushNamed(
                      context,
                      AppRoutes.postDetail,
                      arguments: published?.postId,
                    ),
                  )
                else
                  const FdInfoNote(
                    icon: Icons.lock_outline_rounded,
                    message:
                        'Tus 3 preguntas privadas están activas. Las respuestas nunca se muestran.',
                  ),
                const SizedBox(height: FdSpacing.md),
                if (isLost)
                  const FdInfoNote(
                    message:
                        'Consejo: comparte el reporte en los grupos de tu barrio o de tu universidad.',
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
                children: [
                  if (isLost) ...[
                    FdButton(
                      label: 'Compartir reporte',
                      icon: Icons.ios_share_rounded,
                      variant: FdButtonVariant.secondary,
                      onPressed: () => Navigator.pushNamed(
                        context,
                        AppRoutes.shareReport,
                        arguments: published?.postId,
                      ),
                    ),
                    const SizedBox(height: FdSpacing.sm),
                  ],
                  FdButton(
                    label: 'Volver al inicio',
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
