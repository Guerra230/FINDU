import 'package:flutter/material.dart';

import 'package:findu/core/demo/demo_data.dart';
import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/models/post.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/core/utils/formatters.dart';
import 'package:findu/features/posts/ui/widgets/post_loader.dart';

class BoostArgs {
  const BoostArgs({required this.postId, required this.planIndex});

  final String postId;
  final int planIndex;
}

class BoostScreen extends StatelessWidget {
  const BoostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PostLoader(
      postId: routeId(context),
      builder: (context, post) => _BoostView(post: post),
    );
  }
}

class _BoostView extends StatefulWidget {
  const _BoostView({required this.post});

  final Post post;

  @override
  State<_BoostView> createState() => _BoostViewState();
}

class _BoostViewState extends State<_BoostView> {
  int _plan = 1;

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final plans = DemoData.boostPlans;

    return FdScaffold(
      body: Column(
        children: [
          const FdScreenHeader(title: 'Impulsar publicación'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                FdSpacing.screen,
                FdSpacing.xs,
                FdSpacing.screen,
                FdSpacing.lg,
              ),
              children: [
                FdListRow(
                  leading: PostThumb(post: post),
                  title: post.title,
                  subtitle: post.placeAgo,
                  trailing: FdBadge.status(
                    post.status,
                    feminine: post.feminine,
                  ),
                ),
                const SizedBox(height: FdSpacing.lg),
                Text('Llega a más personas', style: FdTypography.h1),
                const SizedBox(height: FdSpacing.xs),
                Text(
                  'Tu publicación aparece en más mapas y envía alertas a vecinos fuera de tu radio. Alcance actual: 1 km.',
                  style: FdTypography.body.copyWith(
                    color: FdColors.textSecondary,
                  ),
                ),
                const SizedBox(height: FdSpacing.lg),
                FdOptionCards<int>(
                  options: [
                    for (var i = 0; i < plans.length; i++)
                      FdOption(
                        value: i,
                        title:
                            '${plans[i].name} · ${formatCop(plans[i].price)}',
                        subtitle:
                            'Visible en mapas a ${plans[i].radiusKm} km · Alerta a ${plans[i].people} personas · Activo ${plans[i].hours} horas',
                      ),
                  ],
                  selected: _plan,
                  onChanged: (v) => setState(() => _plan = v),
                ),
                const SizedBox(height: FdSpacing.sm),
                FdListRow(
                  leading: const Icon(
                    Icons.credit_card_rounded,
                    color: FdColors.primary,
                  ),
                  title: 'Nequi ····4506',
                  subtitle: 'Método de pago',
                  trailing: Text(
                    'Cambiar',
                    style: FdTypography.bodyStrong.copyWith(
                      color: FdColors.primary,
                    ),
                  ),
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.paymentMethods),
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
