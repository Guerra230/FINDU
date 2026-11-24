import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:findu/core/di/inyeccion.dart';
import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/features/communities/domain/communities_models.dart';
import 'package:findu/features/communities/ui/bloc/communities_cubit.dart';
import 'package:findu/features/communities/ui/widgets/community_parts.dart';

class CommunitiesScreen extends StatelessWidget {
  const CommunitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CommunitiesCubit>()..load(),
      child: const _CommunitiesView(),
    );
  }
}

class _CommunitiesView extends StatelessWidget {
  const _CommunitiesView();

  Future<void> _open(
    BuildContext context,
    String route, {
    Object? arguments,
  }) async {
    final cubit = context.read<CommunitiesCubit>();
    await Navigator.pushNamed(context, route, arguments: arguments);
    cubit.load();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CommunitiesCubit, CommunitiesState>(
      listenWhen: (a, b) => b.error != null && a.error != b.error,
      listener: (context, state) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.error!))),
      builder: (context, state) {
        final cubit = context.read<CommunitiesCubit>();
        return FdScaffold(
          body: Column(
            children: [
              const FdScreenHeader(title: 'Mis comunidades'),
              Expanded(
                child: switch (state.status) {
                  CommunitiesStatus.loading => const FdLoadingState(),
                  CommunitiesStatus.failure when state.items.isEmpty => Center(
                    child: FdErrorState(
                      message: state.error ?? '',
                      onRetry: cubit.load,
                    ),
                  ),
                  _ when state.items.isEmpty => const Center(
                    child: FdEmptyState(
                      mood: FdMood.buscando,
                      title: 'Aún no estás en una comunidad',
                      message:
                          'Únete con el código que te da el admin o crea la tuya.',
                    ),
                  ),
                  _ => RefreshIndicator(
                    onRefresh: cubit.load,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(
                        FdSpacing.screen,
                        FdSpacing.xs,
                        FdSpacing.screen,
                        FdSpacing.lg,
                      ),
                      children: [
                        Text(
                          'Toca una comunidad para cambiar la activa',
                          style: FdTypography.caption,
                        ),
                        const SizedBox(height: FdSpacing.sm),
                        for (final c in state.items)
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: FdSpacing.sm,
                            ),
                            child: _CommunityCard(
                              community: c,
                              onTap: () => cubit.activate(c),
                            ),
                          ),
                        if (state.adminOf.isNotEmpty) ...[
                          const SizedBox(height: FdSpacing.md),
                          Text('Tus paneles', style: FdTypography.h2),
                          const SizedBox(height: FdSpacing.sm),
                          for (final c in state.adminOf)
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: FdSpacing.sm,
                              ),
                              child: FdListRow(
                                leading: const Icon(
                                  Icons.admin_panel_settings_outlined,
                                  color: FdColors.primary,
                                ),
                                title: 'Panel de administración',
                                subtitle: c.name,
                                onTap: () => _open(
                                  context,
                                  AppRoutes.adminPanel,
                                  arguments: c,
                                ),
                              ),
                            ),
                        ],
                      ],
                    ),
                  ),
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  FdSpacing.screen,
                  0,
                  FdSpacing.screen,
                  FdSpacing.md,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FdButton(
                      label: 'Crear una comunidad',
                      variant: FdButtonVariant.secondary,
                      onPressed: () =>
                          _open(context, AppRoutes.createCommunity),
                    ),
                    const SizedBox(height: FdSpacing.sm),
                    FdButton(
                      label: 'Unirme a una comunidad',
                      onPressed: () => _open(context, AppRoutes.joinCommunity),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CommunityCard extends StatelessWidget {
  const _CommunityCard({required this.community, required this.onTap});

  final Community community;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = community;
    return FdGlass(
      strong: true,
      selected: c.isActive,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: FdColors.primarySoft,
              shape: BoxShape.circle,
            ),
            child: Icon(
              c.type == 'Educativa'
                  ? Icons.school_outlined
                  : Icons.apartment_rounded,
              color: FdColors.primary,
            ),
          ),
          const SizedBox(width: FdSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c.name, style: FdTypography.bodyStrong),
                Text(
                  '${c.type} · ${c.members} ${c.members == 1 ? 'miembro' : 'miembros'}',
                  style: FdTypography.caption,
                ),
                const SizedBox(height: FdSpacing.xxs),
                RoleChip(
                  label: c.isPending
                      ? 'Esperando al admin'
                      : (c.isAdmin ? 'Admin' : 'Miembro'),
                ),
              ],
            ),
          ),
          if (c.isActive) const RoleChip(label: 'Activa', highlighted: true),
        ],
      ),
    );
  }
}
