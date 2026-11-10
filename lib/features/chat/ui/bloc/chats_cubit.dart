import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:findu/features/chat/domain/chat_models.dart';
import 'package:findu/features/chat/domain/chat_repository.dart';

enum ChatsStatus { loading, loaded, failure }

class ChatsState {
  const ChatsState({
    this.status = ChatsStatus.loading,
    this.conversations = const [],
  });

  final ChatsStatus status;
  final List<Conversation> conversations;
}

class ChatsCubit extends Cubit<ChatsState> {
  ChatsCubit(this._repository) : super(const ChatsState());

  final ChatRepository _repository;

  Future<void> load() async {
    if (state.conversations.isEmpty) emit(const ChatsState());
    try {
      emit(
        ChatsState(
          status: ChatsStatus.loaded,
          conversations: await _repository.conversations(),
        ),
      );
    } catch (_) {
      emit(
        ChatsState(
          status: ChatsStatus.failure,
          conversations: state.conversations,
        ),
      );
    }
  }
}
