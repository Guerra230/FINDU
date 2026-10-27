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
          const FdResultHero(mood: FdMood.esperando, tag: 'Solicitud enviada'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(FdSpacing.screen),
              children: [
                Text('Solicitud enviada', style: FdTypography.h1),
                const SizedBox(height: FdSpacing.xs),
                Text(
                  'El equipo FINDU revisará la evidencia de $name. Te avisaremos en máximo 48 h.',
                  style: FdTypography.body.copyWith(color: FdColors.textSecondary),
                ),
                const SizedBox(height: FdSpacing.lg),
                const StatusTimeline(
                  steps: ['Solicitud enviada', 'En revisión', 'Comunidad activa y tú como admin'],
                  current: 1,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(FdSpacing.screen, 0, FdSpacing.screen, FdSpacing.md),
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
