import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:findu/core/di/inyeccion.dart';
import 'package:findu/features/notifications/domain/notifications_repository.dart';
import 'package:findu/features/notifications/domain/usecases/notifications_usecases.dart';

enum NotificationsStatus { loading, loaded, failure }

class NotificationsState {
  const NotificationsState({
    this.status = NotificationsStatus.loading,
    this.items = const [],
  });

  final NotificationsStatus status;
  final List<AppNotification> items;

  int get unread => items.where((n) => n.unread).length;
}

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit({
    required ObtenerNotificaciones obtenerNotificaciones,
    required MarcarNotificacionLeida marcarLeida,
    required MarcarTodasLeidas marcarTodas,
  }) : _obtenerNotificaciones = obtenerNotificaciones,
       _marcarLeida = marcarLeida,
       _marcarTodas = marcarTodas,
       super(const NotificationsState());

  final ObtenerNotificaciones _obtenerNotificaciones;
  final MarcarNotificacionLeida _marcarLeida;
  final MarcarTodasLeidas _marcarTodas;

  Future<void> load() async {
    try {
      emit(
        NotificationsState(
          status: NotificationsStatus.loaded,
          items: await _obtenerNotificaciones(),
        ),
      );
    } catch (_) {
      emit(
        NotificationsState(
          status: NotificationsStatus.failure,
          items: state.items,
        ),
      );
    }
  }

  Future<void> markRead(AppNotification notification) async {
    if (!notification.unread) return;
    try {
      await _marcarLeida(notification);
      await load();
    } catch (_) {}
  }

  Future<void> markAllRead() async {
    try {
      await _marcarTodas();
      await load();
    } catch (_) {}
  }
}

class NotificationsScope extends StatelessWidget {
  const NotificationsScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NotificationsCubit>()..load(),
      child: child,
    );
  }
}
