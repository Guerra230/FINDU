import 'package:flutter/material.dart';

import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/features/communities/ui/widgets/community_parts.dart';

class CreateSentScreen extends StatelessWidget {
  const CreateSentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final name = args is String && args.isNotEmpty ? args : 'tu comunidad';

    return Scaffold(
      backgroundColor: FdColors.background,
      body: Column(
        children: [
          const FdResultHero(mood: FdMood.feliz, tag: 'Comunidad creada'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(FdSpacing.screen),
              children: [
                Text('¡$name ya está activa!', style: FdTypography.h1),
                const SizedBox(height: FdSpacing.xs),
                Text(
                  'Eres el administrador. En tu panel encuentras el código de acceso para compartirlo y las solicitudes para unirse.',
                  style: FdTypography.body.copyWith(
                    color: FdColors.textSecondary,
                  ),
                ),
                const SizedBox(height: FdSpacing.lg),
                const StatusTimeline(
                  steps: [
                    'Comunidad creada',
                    'Código de acceso generado',
                    'Comunidad activa y tú como admin',
                  ],
                  current: 3,
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
                    label: 'Ver mis comunidades',
                    variant: FdButtonVariant.secondary,
                    onPressed: () => goToCommunities(context),
                  ),
                  const SizedBox(height: FdSpacing.sm),
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
