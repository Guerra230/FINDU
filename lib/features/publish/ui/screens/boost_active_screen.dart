import 'package:flutter/material.dart';

import 'package:findu/core/demo/demo_data.dart';
import 'package:findu/core/demo/demo_visuals.dart';
import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/features/publish/ui/screens/boost_screen.dart';

class BoostActiveScreen extends StatelessWidget {
  const BoostActiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final boost = args is BoostArgs ? args : const BoostArgs(postId: 'luna', planIndex: 1);
    final post = DemoData.post(boost.postId);
    final plan = DemoData.boostPlans[boost.planIndex];

    return Scaffold(
      backgroundColor: FdColors.background,
      body: Column(
        children: [
          const FdResultHero(mood: FdMood.sorprendido, tag: 'Impulso activo'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(FdSpacing.screen),
              children: [
                Text('${post.title} llega más lejos', style: FdTypography.h1),
                const SizedBox(height: FdSpacing.xs),
                Text(
                  'Estamos enviando alertas a ${plan.radiusKm} km durante las próximas ${plan.hours} horas.',
                  style: FdTypography.body.copyWith(color: FdColors.textSecondary),
                ),
                const SizedBox(height: FdSpacing.lg),
                Row(
                  children: [
                    Expanded(child: _Stat(value: '${plan.people}', label: 'Personas alertadas')),
                    const SizedBox(width: FdSpacing.sm),
                    Expanded(child: _Stat(value: '${plan.radiusKm} km', label: 'Radio en mapas')),
                  ],
                ),
                const SizedBox(height: FdSpacing.sm),
                FdGlass(
                  strong: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text('Tiempo restante', style: FdTypography.bodyStrong)),
                          Text('${plan.hours - 1} h 58 min', style: FdTypography.bodyStrong.copyWith(color: FdColors.primary)),
                        ],
                      ),
                      const SizedBox(height: FdSpacing.sm),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(FdRadius.pill),
                        child: const LinearProgressIndicator(
                          value: 0.03,
                          minHeight: 8,
                          color: FdColors.primary,
                          backgroundColor: FdColors.border,
                        ),
                      ),
                      const SizedBox(height: FdSpacing.sm),
                      Text('Pagaste ${formatCop(plan.price)} con Nequi', style: FdTypography.caption),
                    ],
                  ),
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
