import 'package:findu/features/chat/domain/chat_models.dart';

abstract interface class ChatRepository {
  Future<List<Conversation>> conversations();

  Future<Conversation> conversation(String id);

  Stream<List<ChatMessage>> messages(String conversationId);

  Stream<Delivery> delivery(String conversationId);

  Future<void> send(String conversationId, String text);

  Future<void> markRead(String conversationId);

  Future<DeliveryState> confirmDelivery(String conversationId);

  Future<void> reportProblem(
    String conversationId, {
    required String reason,
    String? detail,
  });
}
