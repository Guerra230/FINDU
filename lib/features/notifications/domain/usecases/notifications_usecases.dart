import 'package:findu/features/notifications/domain/notifications_repository.dart';

class ObtenerNotificaciones {
  const ObtenerNotificaciones(this._repository);

  final NotificationsRepository _repository;

  Future<List<AppNotification>> call() => _repository.all();
}

class MarcarNotificacionLeida {
  const MarcarNotificacionLeida(this._repository);

  final NotificationsRepository _repository;

  Future<void> call(AppNotification notification) async {
    if (!notification.unread) return;
    await _repository.markRead(notification.id);
  }
}

class MarcarTodasLeidas {
  const MarcarTodasLeidas(this._repository);

  final NotificationsRepository _repository;

  Future<void> call() => _repository.markAllRead();
}
