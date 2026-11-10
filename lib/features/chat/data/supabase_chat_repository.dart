import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:findu/features/chat/domain/chat_models.dart';
import 'package:findu/features/chat/domain/chat_repository.dart';

class SupabaseChatRepository implements ChatRepository {
  SupabaseChatRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<List<Conversation>> conversations() async {
    final rows = await _client
        .from('conversaciones')
        .select(Conversation.selectColumns);
    final list = rows.map(Conversation.fromRow).toList()
      ..sort((a, b) => b.lastActivity.compareTo(a.lastActivity));
    return list;
  }

  @override
  Future<Conversation> conversation(String id) async {
    final row = await _client
        .from('conversaciones')
        .select(Conversation.selectColumns)
        .eq('id', id)
        .single();
    return Conversation.fromRow(row);
  }

  @override
  Stream<List<ChatMessage>> messages(String conversationId) => _client
      .from('mensajes')
      .stream(primaryKey: ['id'])
      .eq('conversacion_id', conversationId)
      .order('enviado_en', ascending: true)
      .map((rows) => rows.map(ChatMessage.fromRow).toList());

  @override
  Stream<Delivery> delivery(String conversationId) => _client
      .from('entregas')
      .stream(primaryKey: ['id'])
      .eq('conversacion_id', conversationId)
      .map(
        (rows) => rows.isEmpty ? Delivery.none : Delivery.fromRow(rows.first),
      );

  @override
  Future<void> send(String conversationId, String text) =>
      _client.from('mensajes').insert({
        'conversacion_id': conversationId,
        'emisor_id': _client.auth.currentUser!.id,
        'contenido': text,
      });

  @override
  Future<void> markRead(String conversationId) => _client
      .from('mensajes')
      .update({'leido_en': DateTime.now().toUtc().toIso8601String()})
      .eq('conversacion_id', conversationId)
      .neq('emisor_id', _client.auth.currentUser!.id)
      .isFilter('leido_en', null);

  @override
  Future<DeliveryState> confirmDelivery(String conversationId) async {
    final result = await _client.rpc(
      'confirmar_entrega',
      params: {'p_conversacion': conversationId},
    );
    return parseDeliveryState(result as String?);
  }

  @override
  Future<void> reportProblem(
    String conversationId, {
    required String reason,
    String? detail,
  }) => _client.rpc(
    'reportar_problema',
    params: {
      'p_conversacion': conversationId,
      'p_motivo': reason,
      'p_detalle': detail ?? '',
    },
  );
}
