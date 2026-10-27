import 'package:flutter/material.dart';

import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/features/publish/ui/widgets/publish_parts.dart';

class PublishedScreen extends StatelessWidget {
  const PublishedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final kind = args is String ? args : PublishKinds.petLost;
    final isPet = kind == PublishKinds.petLost || kind == PublishKinds.petFound;
    final isLost = kind == PublishKinds.objectLost || kind == PublishKinds.petLost;

    final title = switch (kind) {
      PublishKinds.objectLost || PublishKinds.objectFound => '¡Objeto publicado!',
      PublishKinds.petLost => '¡Reporte publicado!',
      _ => '¡Mascota reportada!',
    };
    final message = isLost
        ? 'Alertamos a 128 vecinos a menos de 1 km. Te avisaremos cuando alguien lo vea.'
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
                Text(message, style: FdTypography.body.copyWith(color: FdColors.textSecondary)),
                const SizedBox(height: FdSpacing.lg),
                if (isLost)
                  const Row(
                    children: [
                      Expanded(child: _Stat(value: '1 km', label: 'Radio de alerta')),
                      SizedBox(width: FdSpacing.sm),
                      Expanded(child: _Stat(value: '128', label: 'Vecinos avisados')),
                    ],
                  )
                else
                  const FdInfoNote(
                    icon: Icons.lock_outline_rounded,
                    message: 'Tus 3 preguntas privadas están activas. Las respuestas nunca se muestran.',
                  ),
                const SizedBox(height: FdSpacing.md),
                if (isLost)
                  const FdInfoNote(
                    message: 'Consejo: comparte el reporte en los grupos de tu barrio o de tu universidad.',
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(FdSpacing.screen, 0, FdSpacing.screen, FdSpacing.md),
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  if (isLost) ...[
                    FdButton(
                      label: 'Compartir reporte',
                      icon: Icons.ios_share_rounded,
                      variant: FdButtonVariant.secondary,
                      onPressed: () => Navigator.pushNamed(context, AppRoutes.shareReport, arguments: isPet ? 'luna' : 'xiaomi'),
                    ),
                    const SizedBox(height: FdSpacing.sm),
                  ],
                  FdButton(
                    label: 'Volver al inicio',
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

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return FdGlass(
      strong: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: FdTypography.h1.copyWith(color: FdColors.primary)),
          Text(label, style: FdTypography.caption),
        ],
      ),
    );
  }
}
