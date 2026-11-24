import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:findu/core/di/inyeccion.dart';
import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/models/post.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/core/utils/formatters.dart';
import 'package:findu/features/payments/domain/payments_models.dart';
import 'package:findu/features/payments/ui/bloc/boost_cubit.dart';
import 'package:findu/features/posts/ui/widgets/post_loader.dart';

class BoostArgs {
  const BoostArgs({required this.post, required this.result});

  final Post post;
  final BoostResult result;
}

class BoostScreen extends StatelessWidget {
  const BoostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PostLoader(
      postId: routeId(context),
      builder: (context, post) => BlocProvider(
        create: (_) => sl<BoostCubit>(param1: post.id)..load(),
        child: _BoostView(post: post),
      ),
    );
  }
}

class _BoostView extends StatelessWidget {
  const _BoostView({required this.post});

  final Post post;

  void _onState(BuildContext context, BoostState state) {
    if (state.status == BoostStatus.done && state.result != null) {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.boostActive,
        arguments: BoostArgs(post: post, result: state.result!),
      );
    }
    if (state.error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.error!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BoostCubit, BoostState>(
      listenWhen: (a, b) =>
          a.status != b.status || (b.error != null && a.error != b.error),
      listener: _onState,
      builder: (context, state) {
        final cubit = context.read<BoostCubit>();
        if (state.status == BoostStatus.loading) {
          return const FdScaffold(body: FdLoadingState());
        }
        final plans = state.plans;
        final plan = state.plan;
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
                    if (plans.isEmpty)
                      FdErrorState(
                        message: 'No hay planes disponibles.',
                        onRetry: cubit.load,
                      )
                    else
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
                        selected: state.selected,
                        onChanged: cubit.select,
                      ),
                    const SizedBox(height: FdSpacing.sm),
                    FdListRow(
                      leading: const Icon(
                        Icons.credit_card_rounded,
                        color: FdColors.primary,
                      ),
                      title: state.method?.label ?? 'Nequi',
                      subtitle: state.method == null
                          ? 'Pago simulado, se crea al pagar'
                          : 'Método de pago',
                      trailing: Text(
                        'Cambiar',
                        style: FdTypography.bodyStrong.copyWith(
                          color: FdColors.primary,
                        ),
                      ),
                      onTap: () async {
                        await Navigator.pushNamed(
                          context,
                          AppRoutes.paymentMethods,
                        );
                        cubit.load();
                      },
                    ),
                    const SizedBox(height: FdSpacing.md),
                    const FdInfoNote(
                      icon: Icons.lock_outline_rounded,
                      message:
                          'Pago simulado para la entrega: no se cobra dinero real ni se guardan datos de tarjeta.',
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
                  label: plan == null
                      ? 'Impulsar'
                      : 'Pagar ${formatCop(plan.price)} e impulsar',
                  isLoading: state.status == BoostStatus.paying,
                  onPressed: plan == null || state.status == BoostStatus.paying
                      ? null
                      : cubit.pay,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
