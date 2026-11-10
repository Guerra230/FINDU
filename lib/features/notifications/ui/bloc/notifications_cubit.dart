import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:findu/features/notifications/domain/notifications_repository.dart';

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
  NotificationsCubit(this._repository) : super(const NotificationsState());

  final NotificationsRepository _repository;

  Future<void> load() async {
    try {
      emit(
        NotificationsState(
          status: NotificationsStatus.loaded,
          items: await _repository.all(),
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
      await _repository.markRead(notification.id);
      await load();
    } catch (_) {}
  }

  Future<void> markAllRead() async {
    try {
      await _repository.markAllRead();
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
      create: (context) =>
          NotificationsCubit(context.read<NotificationsRepository>())..load(),
      child: child,
    );
  }
}
