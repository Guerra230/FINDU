import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:findu/features/notifications/domain/notifications_repository.dart';

class SupabaseNotificationsRepository implements NotificationsRepository {
  SupabaseNotificationsRepository(this._client);

  final SupabaseClient _client;

  String get _now => DateTime.now().toUtc().toIso8601String();

  @override
  Future<List<AppNotification>> all() async {
    final rows = await _client
        .from('notificaciones')
        .select()
        .order('creado_en', ascending: false)
        .limit(100);
    return rows.map(AppNotification.fromRow).toList();
  }

  @override
  Future<void> markRead(String id) =>
      _client.from('notificaciones').update({'leida_en': _now}).eq('id', id);

  @override
  Future<void> markAllRead() => _client
      .from('notificaciones')
      .update({'leida_en': _now})
      .eq('perfil_id', _client.auth.currentUser!.id)
      .isFilter('leida_en', null);
}
