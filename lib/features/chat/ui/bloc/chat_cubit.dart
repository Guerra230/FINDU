import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:findu/features/chat/domain/chat_models.dart';
import 'package:findu/features/chat/domain/usecases/chat_usecases.dart';

enum ChatStatus { loading, ready, failure }

class ChatState {
  const ChatState({
    this.status = ChatStatus.loading,
    this.conversation,
    this.messages = const [],
    this.delivery = Delivery.none,
    this.confirming = false,
    this.error,
  });

  final ChatStatus status;
  final Conversation? conversation;
  final List<ChatMessage> messages;
  final Delivery delivery;
  final bool confirming;
  final String? error;

  bool get iConfirmed =>
      conversation != null &&
      delivery.confirmedBy(owner: conversation!.iAmOwner);

  bool get otherConfirmed =>
      conversation != null &&
      delivery.confirmedBy(owner: !conversation!.iAmOwner);

  ChatState copyWith({
    ChatStatus? status,
    Conversation? conversation,
    List<ChatMessage>? messages,
    Delivery? delivery,
    bool? confirming,
    String? error,
  }) => ChatState(
    status: status ?? this.status,
    conversation: conversation ?? this.conversation,
    messages: messages ?? this.messages,
    delivery: delivery ?? this.delivery,
    confirming: confirming ?? this.confirming,
    error: error,
  );
}

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({
    required ObtenerConversacion obtenerConversacion,
    required EscucharMensajes escucharMensajes,
    required EscucharEntrega escucharEntrega,
    required EnviarMensaje enviarMensaje,
    required MarcarMensajesLeidos marcarLeidos,
    required ConfirmarEntrega confirmarEntrega,
    required this.conversationId,
  }) : _obtenerConversacion = obtenerConversacion,
       _escucharMensajes = escucharMensajes,
       _escucharEntrega = escucharEntrega,
       _enviarMensaje = enviarMensaje,
       _marcarLeidos = marcarLeidos,
       _confirmarEntrega = confirmarEntrega,
       super(const ChatState());

  final ObtenerConversacion _obtenerConversacion;
  final EscucharMensajes _escucharMensajes;
  final EscucharEntrega _escucharEntrega;
  final EnviarMensaje _enviarMensaje;
  final MarcarMensajesLeidos _marcarLeidos;
  final ConfirmarEntrega _confirmarEntrega;
  final String conversationId;
  StreamSubscription<List<ChatMessage>>? _messages;
  StreamSubscription<Delivery>? _delivery;

  Future<void> load() async {
    emit(const ChatState());
    try {
      final conversation = await _obtenerConversacion(conversationId);
      emit(
        state.copyWith(status: ChatStatus.ready, conversation: conversation),
      );
      await _messages?.cancel();
      await _delivery?.cancel();
      _messages = _escucharMensajes(conversationId).listen((list) {
        emit(state.copyWith(messages: list));
        if (list.any((m) => !m.mine && m.readAt == null)) {
          _marcarLeidos(conversationId).ignore();
        }
      });
      _delivery = _escucharEntrega(
        conversationId,
      ).listen((d) => emit(state.copyWith(delivery: d)));
    } catch (_) {
      emit(const ChatState(status: ChatStatus.failure));
    }
  }

  Future<bool> send(String text) async {
    try {
      return await _enviarMensaje(conversationId, text);
    } catch (_) {
      emit(state.copyWith(error: 'No se pudo enviar el mensaje.'));
      return false;
    }
  }

  Future<void> confirmDelivery() async {
    emit(state.copyWith(confirming: true));
    try {
      final result = await _confirmarEntrega(conversationId);
      final d = state.delivery;
      final iAmOwner = state.conversation!.iAmOwner;
      emit(
        state.copyWith(
          confirming: false,
          delivery: Delivery(
            state: result,
            ownerConfirmed: d.ownerConfirmed || iAmOwner,
            counterpartConfirmed: d.counterpartConfirmed || !iAmOwner,
          ),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          confirming: false,
          error: 'No pudimos confirmar la entrega.',
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    await _messages?.cancel();
    await _delivery?.cancel();
    return super.close();
  }
}

enum ProblemStatus { editing, sending, sent, failure }

class DeliveryProblemCubit extends Cubit<ProblemStatus> {
  DeliveryProblemCubit(this._reportarProblema) : super(ProblemStatus.editing);

  final ReportarProblemaEntrega _reportarProblema;

  Future<void> send(
    String conversationId, {
    required String reason,
    String? detail,
  }) async {
    emit(ProblemStatus.sending);
    try {
      await _reportarProblema(conversationId, reason: reason, detail: detail);
      emit(ProblemStatus.sent);
    } catch (_) {
      emit(ProblemStatus.failure);
    }
  }
}
