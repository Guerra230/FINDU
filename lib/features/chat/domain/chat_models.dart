import 'package:findu/core/models/post.dart';
import 'package:findu/core/supabase/supabase_setup.dart';

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.text,
    required this.sentAt,
    this.readAt,
  });

  factory ChatMessage.fromRow(Map<String, dynamic> row) => ChatMessage(
    id: row['id'] as String,
    conversationId: row['conversacion_id'] as String,
    senderId: row['emisor_id'] as String,
    text: row['contenido'] as String,
    sentAt: DateTime.parse(row['enviado_en'] as String),
    readAt: row['leido_en'] == null
        ? null
        : DateTime.parse(row['leido_en'] as String),
  );

  final String id;
  final String conversationId;
  final String senderId;
  final String text;
  final DateTime sentAt;
  final DateTime? readAt;

  bool get mine => senderId == SupabaseSetup.userId;
}

class Conversation {
  const Conversation({
    required this.id,
    required this.post,
    required this.ownerId,
    required this.ownerName,
    required this.counterpartId,
    required this.counterpartName,
    required this.open,
    required this.viaVerification,
    required this.openedAt,
    this.lastMessage,
  });

  static const selectColumns =
      'id, dueno_id, contraparte_id, estado, abierta_en, intento_id, '
      'dueno:perfiles!conversaciones_dueno_id_fkey(nombre), '
      'contraparte:perfiles!conversaciones_contraparte_id_fkey(nombre), '
      'publicacion:publicaciones(${Post.selectColumns}), '
      'mensajes(id, conversacion_id, emisor_id, contenido, enviado_en, leido_en)';

  factory Conversation.fromRow(Map<String, dynamic> row) {
    final messages =
        (row['mensajes'] as List? ?? const [])
            .map((m) => ChatMessage.fromRow(m as Map<String, dynamic>))
            .toList()
          ..sort((a, b) => a.sentAt.compareTo(b.sentAt));
    return Conversation(
      id: row['id'] as String,
      post: Post.fromRow(row['publicacion'] as Map<String, dynamic>),
      ownerId: row['dueno_id'] as String,
      ownerName: (row['dueno'] as Map?)?['nombre'] as String? ?? 'Usuario',
      counterpartId: row['contraparte_id'] as String,
      counterpartName:
          (row['contraparte'] as Map?)?['nombre'] as String? ?? 'Usuario',
      open: row['estado'] == 'abierta',
      viaVerification: row['intento_id'] != null,
      openedAt: DateTime.parse(row['abierta_en'] as String),
      lastMessage: messages.isEmpty ? null : messages.last,
    );
  }

  final String id;
  final Post post;
  final String ownerId;
  final String ownerName;
  final String counterpartId;
  final String counterpartName;
  final bool open;
  final bool viaVerification;
  final DateTime openedAt;
  final ChatMessage? lastMessage;

  bool get iAmOwner => ownerId == SupabaseSetup.userId;

  bool get iFoundIt => !iAmOwner;

  String get otherName => iAmOwner ? counterpartName : ownerName;

  String get otherFirstName => otherName.split(' ').first;

  bool get unread =>
      lastMessage != null && !lastMessage!.mine && lastMessage!.readAt == null;

  DateTime get lastActivity => lastMessage?.sentAt ?? openedAt;

  String get summary {
    final article = post.feminine ? 'la' : 'el';
    final item = post.isPet
        ? 'a ${post.title}'
        : '$article ${post.title.toLowerCase()}';
    if (iFoundIt) {
      return viaVerification
          ? '$otherFirstName verificó que es suyo'
          : 'Encontraste $item · fotos enviadas';
    }
    return viaVerification
        ? 'Verificaste que es ${post.feminine ? 'tuya' : 'tuyo'}'
        : '$otherFirstName encontró $item';
  }
}

enum DeliveryState { pending, confirmed, problem }

class Delivery {
  const Delivery({
    required this.state,
    required this.ownerConfirmed,
    required this.counterpartConfirmed,
  });

  factory Delivery.fromRow(Map<String, dynamic> row) => Delivery(
    state: parseDeliveryState(row['estado'] as String?),
    ownerConfirmed: row['confirmo_dueno_en'] != null,
    counterpartConfirmed: row['confirmo_contraparte_en'] != null,
  );

  static const none = Delivery(
    state: DeliveryState.pending,
    ownerConfirmed: false,
    counterpartConfirmed: false,
  );

  final DeliveryState state;
  final bool ownerConfirmed;
  final bool counterpartConfirmed;

  bool confirmedBy({required bool owner}) =>
      owner ? ownerConfirmed : counterpartConfirmed;
}

DeliveryState parseDeliveryState(String? value) => switch (value) {
  'confirmada' => DeliveryState.confirmed,
  'con_problema' => DeliveryState.problem,
  _ => DeliveryState.pending,
};
