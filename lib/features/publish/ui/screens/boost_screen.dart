import 'package:flutter/material.dart';

import 'package:findu/core/demo/demo_data.dart';
import 'package:findu/core/demo/demo_visuals.dart';
import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_routes.dart';

class BoostArgs {
  const BoostArgs({required this.postId, required this.planIndex});

  final String postId;
  final int planIndex;
}

class BoostScreen extends StatefulWidget {
  const BoostScreen({super.key});

  @override
  State<BoostScreen> createState() => _BoostScreenState();
}

class _BoostScreenState extends State<BoostScreen> {
  int _plan = 1;

  @override
  Widget build(BuildContext context) {
    final post = DemoData.post(routeId(context));
    final plans = DemoData.boostPlans;

    return FdScaffold(
      body: Column(
        children: [
          const FdScreenHeader(title: 'Impulsar publicación'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(FdSpacing.screen, FdSpacing.xs, FdSpacing.screen, FdSpacing.lg),
              children: [
                FdListRow(
                  leading: Icon(post.icon, color: FdColors.primary, size: 32),
                  title: post.title,
                  subtitle: post.placeAgo,
                  trailing: FdBadge.status(post.status, feminine: post.feminine),
                ),
                const SizedBox(height: FdSpacing.lg),
                Text('Llega a más personas', style: FdTypography.h1),
                const SizedBox(height: FdSpacing.xs),
                Text(
                  'Tu publicación aparece en más mapas y envía alertas a vecinos fuera de tu radio. Alcance actual: 1 km.',
                  style: FdTypography.body.copyWith(color: FdColors.textSecondary),
                ),
                const SizedBox(height: FdSpacing.lg),
                FdOptionCards<int>(
                  options: [
                    for (var i = 0; i < plans.length; i++)
                      FdOption(
                        value: i,
                        title: '${plans[i].name} · ${formatCop(plans[i].price)}',
                        subtitle:
                            'Visible en mapas a ${plans[i].radiusKm} km · Alerta a ${plans[i].people} personas · Activo ${plans[i].hours} horas',
                      ),
                  ],
                  selected: _plan,
                  onChanged: (v) => setState(() => _plan = v),
                ),
                const SizedBox(height: FdSpacing.sm),
                FdListRow(
                  leading: const Icon(Icons.credit_card_rounded, color: FdColors.primary),
                  title: 'Nequi ····4506',
                  subtitle: 'Método de pago',
                  trailing: Text('Cambiar', style: FdTypography.bodyStrong.copyWith(color: FdColors.primary)),
                  onTap: () => Navigator.pushNamed(context, AppRoutes.paymentMethods),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(FdSpacing.screen, 0, FdSpacing.screen, FdSpacing.md),
            child: FdButton(
              label: 'Pagar ${formatCop(plans[_plan].price)} e impulsar',
              onPressed: () => Navigator.pushReplacementNamed(
                context,
                AppRoutes.boostActive,
                arguments: BoostArgs(postId: post.id, planIndex: _plan),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
