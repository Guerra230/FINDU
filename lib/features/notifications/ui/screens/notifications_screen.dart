import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/core/utils/formatters.dart';
import 'package:findu/features/notifications/domain/notifications_repository.dart';
import 'package:findu/features/notifications/ui/bloc/notifications_cubit.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const NotificationsScope(child: _NotificationsView());
  }
}

class _NotificationsView extends StatefulWidget {
  const _NotificationsView();

  @override
  State<_NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<_NotificationsView> {
  bool _onlyUnread = false;

  IconData _iconFor(AppNotification n) => switch (n.type) {
    'verificacion' => Icons.verified_outlined,
    'recompensa' => Icons.payments_outlined,
    'avistamiento' => Icons.visibility_outlined,
    'mensaje' => Icons.chat_bubble_outline_rounded,
    'reencuentro' => Icons.favorite_border_rounded,
    'comunidad' => Icons.groups_outlined,
    'impulso' => Icons.rocket_launch_outlined,
    _ => Icons.search_rounded,
  };

  void _open(AppNotification n) {
    context.read<NotificationsCubit>().markRead(n);
    if (n.conversationId != null) {
      Navigator.pushNamed(context, AppRoutes.chat, arguments: n.conversationId);
    } else if (n.postId != null) {
      Navigator.pushNamed(context, AppRoutes.postDetail, arguments: n.postId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<NotificationsCubit>();
    final state = cubit.state;
    final items = state.items.where((n) => !_onlyUnread || n.unread).toList();

    return FdScaffold(
      body: Column(
        children: [
          FdScreenHeader(
            title: 'Notificaciones',
            trailing: FdIconButton(
              icon: Icons.tune_rounded,
              tooltip: 'Configurar alertas',
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.alertSettings),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: FdChipBar<bool>(
                  options: const {false: 'Todas', true: 'Sin leer'},
                  selected: _onlyUnread,
                  onChanged: (v) => setState(() => _onlyUnread = v),
                ),
              ),
              if (state.unread > 0)
                TextButton(
                  onPressed: cubit.markAllRead,
                  child: const Text('Marcar leídas'),
                ),
              const SizedBox(width: FdSpacing.sm),
            ],
          ),
          Expanded(
            child: switch (state.status) {
              NotificationsStatus.loading => const FdLoadingState(),
              NotificationsStatus.failure when items.isEmpty => Center(
                child: FdErrorState(
                  message: 'No pudimos cargar tus notificaciones.',
                  onRetry: cubit.load,
                ),
              ),
              _ when items.isEmpty => const Center(
                child: FdEmptyState(
                  mood: FdMood.feliz,
                  title: 'Estás al día',
                  message: 'No tienes notificaciones por ahora.',
                ),
              ),
              _ => RefreshIndicator(
                onRefresh: cubit.load,
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    FdSpacing.screen,
                    FdSpacing.md,
                    FdSpacing.screen,
                    FdSpacing.xl,
                  ),
                  itemCount: items.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: FdSpacing.sm),
                  itemBuilder: (context, i) {
                    final n = items[i];
                    return FdListRow(
                      leading: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: FdColors.primarySoft,
                          borderRadius: BorderRadius.circular(FdRadius.sm),
                        ),
                        child: Icon(_iconFor(n), color: FdColors.primary),
                      ),
                      title: n.title,
                      subtitle: n.body,
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            shortTime(n.createdAt),
                            style: FdTypography.caption,
                          ),
                          const SizedBox(height: FdSpacing.xs),
                          if (n.unread)
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: FdColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      onTap: () => _open(n),
                    );
                  },
                ),
              ),
            },
          ),
        ],
      ),
    );
  }
}
