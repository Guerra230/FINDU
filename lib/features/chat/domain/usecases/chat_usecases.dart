import 'package:findu/features/chat/domain/chat_models.dart';
import 'package:findu/features/chat/domain/chat_repository.dart';

class ObtenerConversaciones {
  const ObtenerConversaciones(this._repository);

  final ChatRepository _repository;

  Future<List<Conversation>> call() => _repository.conversations();
}

class ObtenerConversacion {
  const ObtenerConversacion(this._repository);

  final ChatRepository _repository;

  Future<Conversation> call(String id) => _repository.conversation(id);
}

class EscucharMensajes {
  const EscucharMensajes(this._repository);

  final ChatRepository _repository;

  Stream<List<ChatMessage>> call(String conversationId) =>
      _repository.messages(conversationId);
}

class EscucharEntrega {
  const EscucharEntrega(this._repository);

  final ChatRepository _repository;

  Stream<Delivery> call(String conversationId) =>
      _repository.delivery(conversationId);
}

class EnviarMensaje {
  const EnviarMensaje(this._repository);

  final ChatRepository _repository;

  Future<bool> call(String conversationId, String text) async {
    final value = text.trim();
    if (value.isEmpty) return false;
    await _repository.send(conversationId, value);
    return true;
  }
}

class MarcarMensajesLeidos {
  const MarcarMensajesLeidos(this._repository);

  final ChatRepository _repository;

  Future<void> call(String conversationId) =>
      _repository.markRead(conversationId);
}

class ConfirmarEntrega {
  const ConfirmarEntrega(this._repository);

  final ChatRepository _repository;

  Future<DeliveryState> call(String conversationId) =>
      _repository.confirmDelivery(conversationId);
}

class ReportarProblemaEntrega {
  const ReportarProblemaEntrega(this._repository);

  final ChatRepository _repository;

  Future<void> call(
    String conversationId, {
    required String reason,
    String? detail,
  }) =>
      _repository.reportProblem(conversationId, reason: reason, detail: detail);
}
