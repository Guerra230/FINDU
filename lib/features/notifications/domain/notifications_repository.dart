class AppNotification {
  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.createdAt,
    this.postId,
    this.conversationId,
    this.readAt,
  });

  factory AppNotification.fromRow(Map<String, dynamic> row) => AppNotification(
    id: row['id'] as String,
    type: row['tipo'] as String,
    title: row['titulo'] as String,
    body: row['cuerpo'] as String,
    createdAt: DateTime.parse(row['creado_en'] as String),
    postId: row['publicacion_id'] as String?,
    conversationId: row['conversacion_id'] as String?,
    readAt: row['leida_en'] == null
        ? null
        : DateTime.parse(row['leida_en'] as String),
  );

  final String id;
  final String type;
  final String title;
  final String body;
  final DateTime createdAt;
  final String? postId;
  final String? conversationId;
  final DateTime? readAt;

  bool get unread => readAt == null;
}

abstract interface class NotificationsRepository {
  Future<List<AppNotification>> all();

  Future<void> markRead(String id);

  Future<void> markAllRead();
}
