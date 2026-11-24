import 'package:flutter/material.dart';

import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/utils/formatters.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/features/publish/ui/screens/boost_screen.dart';

class BoostActiveScreen extends StatelessWidget {
  const BoostActiveScreen({super.key});

  String _remaining(DateTime endsAt) {
    final diff = endsAt.difference(DateTime.now());
    if (diff.isNegative) return 'Terminó';
    return '${diff.inHours} h ${diff.inMinutes.remainder(60)} min';
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is! BoostArgs) {
      return FdScaffold(
        body: Center(
          child: FdErrorState(
            message: 'Impulsa una publicación desde su detalle.',
            onRetry: () => Navigator.maybePop(context),
          ),
        ),
      );
    }
    final post = args.post;
    final plan = args.result.plan;
    final total = Duration(hours: plan.hours).inMinutes;
    final left = args.result.endsAt
        .difference(DateTime.now())
        .inMinutes
        .clamp(0, total);
    final progress = total == 0 ? 1.0 : 1 - left / total;

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
                  style: FdTypography.body.copyWith(
                    color: FdColors.textSecondary,
                  ),
                ),
                const SizedBox(height: FdSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: _Stat(
                        value: '${plan.people}',
                        label: 'Personas alertadas',
                      ),
                    ),
                    const SizedBox(width: FdSpacing.sm),
                    Expanded(
                      child: _Stat(
                        value: '${plan.radiusKm} km',
                        label: 'Radio en mapas',
                      ),
                    ),
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
                          Expanded(
                            child: Text(
                              'Tiempo restante',
                              style: FdTypography.bodyStrong,
                            ),
                          ),
                          Text(
                            _remaining(args.result.endsAt),
                            style: FdTypography.bodyStrong.copyWith(
                              color: FdColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: FdSpacing.sm),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(FdRadius.pill),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 8,
                          color: FdColors.primary,
                          backgroundColor: FdColors.border,
                        ),
                      ),
                      const SizedBox(height: FdSpacing.sm),
                      Text(
                        'Pagaste ${formatCop(plan.price)} con ${args.result.method}',
                        style: FdTypography.caption,
                      ),
                    ],
                  ),
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
              child: FdButton(
                label: 'Volver al inicio',
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.main,
                  (_) => false,
                ),
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
