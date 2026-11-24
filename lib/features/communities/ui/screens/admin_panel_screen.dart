import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:findu/core/di/inyeccion.dart';
import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/features/communities/domain/communities_models.dart';
import 'package:findu/features/communities/ui/bloc/admin_panel_cubit.dart';

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final community = ModalRoute.of(context)?.settings.arguments;
    if (community is! Community) {
      return FdScaffold(
        body: Center(
          child: FdErrorState(
            message: 'Abre el panel desde Mis comunidades.',
            onRetry: () => Navigator.maybePop(context),
          ),
        ),
      );
    }
    return BlocProvider(
      create: (_) => sl<AdminPanelCubit>(param1: community.id)..load(),
      child: _AdminPanelView(community: community),
    );
  }
}

class _AdminPanelView extends StatelessWidget {
  const _AdminPanelView({required this.community});

  final Community community;

  Future<void> _copy(BuildContext context, String code) async {
    await Clipboard.setData(ClipboardData(text: code));
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Código copiado')));
  }

  String _expires(DateTime? date) {
    if (date == null) return '';
    const months = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];
    final d = date.toLocal();
    return ' · vence el ${d.day} de ${months[d.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminPanelCubit, AdminPanelState>(
      listenWhen: (a, b) =>
          b.message != null &&
          a.message != b.message &&
          b.status == AdminPanelStatus.loaded,
      listener: (context, state) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.message!))),
      builder: (context, state) {
        final cubit = context.read<AdminPanelCubit>();
        if (state.status == AdminPanelStatus.loading) {
          return const FdScaffold(body: FdLoadingState());
        }
        final panel = state.panel;
        if (panel == null) {
          return FdScaffold(
            body: Column(
              children: [
                const FdScreenHeader(title: 'Panel de administración'),
                Expanded(
                  child: Center(
                    child: FdErrorState(
                      message: state.message ?? '',
                      onRetry: cubit.load,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        final requests = panel.requests;
        return FdScaffold(
          body: Column(
            children: [
              const FdScreenHeader(title: 'Panel de administración'),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(
                    FdSpacing.screen,
                    FdSpacing.xs,
                    FdSpacing.screen,
                    FdSpacing.lg,
                  ),
                  children: [
                    Text(
                      '${community.name} · ${community.members} miembros · Eres admin',
                      style: FdTypography.caption,
                    ),
                    const SizedBox(height: FdSpacing.md),
                    FdGlass(
                      strong: true,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Código de acceso',
                            style: FdTypography.bodyStrong,
                          ),
                          const SizedBox(height: FdSpacing.xs),
                          Text(
                            panel.code,
                            style: FdTypography.display.copyWith(
                              color: FdColors.primary,
                            ),
                          ),
                          Text(
                            '${panel.uses} de ${panel.maxUses} usos${_expires(panel.expiresAt)}',
                            style: FdTypography.caption,
                          ),
                          const SizedBox(height: FdSpacing.md),
                          Row(
                            children: [
                              Expanded(
                                child: FdButton(
                                  label: 'Copiar',
                                  icon: Icons.copy_rounded,
                                  variant: FdButtonVariant.secondary,
                                  onPressed: () => _copy(context, panel.code),
                                ),
                              ),
                              const SizedBox(width: FdSpacing.sm),
                              Expanded(
                                child: FdButton(
                                  label: 'Generar nuevo',
                                  variant: FdButtonVariant.secondary,
                                  onPressed: cubit.newCode,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: FdSpacing.lg),
                    Text(
                      'Solicitudes pendientes (${requests.length})',
                      style: FdTypography.h2,
                    ),
                    const SizedBox(height: FdSpacing.sm),
                    if (requests.isEmpty)
                      const FdEmptyState(
                        mood: FdMood.feliz,
                        title: 'Sin solicitudes',
                        message:
                            'Cuando alguien pida unirse sin código, aparecerá aquí.',
                      )
                    else
                      for (final request in requests)
                        Padding(
                          padding: const EdgeInsets.only(bottom: FdSpacing.sm),
                          child: FdGlass(
                            strong: true,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    FdAvatar(name: request.name),
                                    const SizedBox(width: FdSpacing.sm),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            request.name,
                                            style: FdTypography.bodyStrong,
                                          ),
                                          Text(
                                            'Solicitó unirse sin código',
                                            style: FdTypography.caption,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: FdSpacing.sm),
                                Row(
                                  children: [
                                    Expanded(
                                      child: FdButton(
                                        label: 'Rechazar',
                                        variant: FdButtonVariant.danger,
                                        onPressed: () => cubit.resolve(
                                          request,
                                          accept: false,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: FdSpacing.sm),
                                    Expanded(
                                      child: FdButton(
                                        label: 'Aceptar',
                                        variant: FdButtonVariant.secondary,
                                        icon: Icons.check_rounded,
                                        onPressed: () => cubit.resolve(
                                          request,
                                          accept: true,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                    const SizedBox(height: FdSpacing.sm),
                    const FdInfoNote(
                      message:
                          'Solo los administradores pueden aceptar miembros y crear códigos de acceso.',
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
