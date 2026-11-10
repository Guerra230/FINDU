import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:findu/features/chat/domain/chat_models.dart';
import 'package:findu/features/chat/domain/chat_repository.dart';

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
  ChatCubit(this._repository, this.conversationId) : super(const ChatState());

  final ChatRepository _repository;
  final String conversationId;
  StreamSubscription<List<ChatMessage>>? _messages;
  StreamSubscription<Delivery>? _delivery;

  Future<void> load() async {
    emit(const ChatState());
    try {
      final conversation = await _repository.conversation(conversationId);
      emit(
        state.copyWith(status: ChatStatus.ready, conversation: conversation),
      );
      await _messages?.cancel();
      await _delivery?.cancel();
      _messages = _repository.messages(conversationId).listen((list) {
        emit(state.copyWith(messages: list));
        if (list.any((m) => !m.mine && m.readAt == null)) {
          _repository.markRead(conversationId).ignore();
        }
      });
      _delivery = _repository
          .delivery(conversationId)
          .listen((d) => emit(state.copyWith(delivery: d)));
    } catch (_) {
      emit(const ChatState(status: ChatStatus.failure));
    }
  }

  Future<bool> send(String text) async {
    final value = text.trim();
    if (value.isEmpty) return false;
    try {
      await _repository.send(conversationId, value);
      return true;
    } catch (_) {
      emit(state.copyWith(error: 'No se pudo enviar el mensaje.'));
      return false;
    }
  }

  Future<void> confirmDelivery() async {
    emit(state.copyWith(confirming: true));
    try {
      final result = await _repository.confirmDelivery(conversationId);
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
  DeliveryProblemCubit(this._repository) : super(ProblemStatus.editing);

  final ChatRepository _repository;

  Future<void> send(
    String conversationId, {
    required String reason,
    String? detail,
  }) async {
    emit(ProblemStatus.sending);
    try {
      await _repository.reportProblem(
        conversationId,
        reason: reason,
        detail: detail,
      );
      emit(ProblemStatus.sent);
    } catch (_) {
      emit(ProblemStatus.failure);
    }
  }
}
