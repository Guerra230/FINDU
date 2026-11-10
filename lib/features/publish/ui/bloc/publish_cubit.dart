import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:findu/features/posts/domain/posts_repository.dart';

enum PublishStatus { editing, sending, done, failure }

class PublishState {
  const PublishState({this.status = PublishStatus.editing, this.postId});

  final PublishStatus status;
  final String? postId;
}

class PublishCubit extends Cubit<PublishState> {
  PublishCubit(this._repository) : super(const PublishState());

  final PostsRepository _repository;

  Future<void> publish(NewPost post) async {
    emit(const PublishState(status: PublishStatus.sending));
    try {
      emit(
        PublishState(
          status: PublishStatus.done,
          postId: await _repository.create(post),
        ),
      );
    } catch (_) {
      emit(const PublishState(status: PublishStatus.failure));
    }
  }
}
