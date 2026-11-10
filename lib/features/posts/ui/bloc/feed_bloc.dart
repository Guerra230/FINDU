import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:findu/core/models/post.dart';
import 'package:findu/features/posts/domain/posts_repository.dart';

sealed class FeedEvent {
  const FeedEvent();
}

final class FeedRequested extends FeedEvent {
  const FeedRequested();
}

enum FeedStatus { loading, loaded, failure }

class FeedState {
  const FeedState({this.status = FeedStatus.loading, this.posts = const []});

  final FeedStatus status;
  final List<Post> posts;
}

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  FeedBloc(this._repository) : super(const FeedState()) {
    on<FeedRequested>(_onRequested);
  }

  final PostsRepository _repository;

  Future<void> _onRequested(
    FeedRequested event,
    Emitter<FeedState> emit,
  ) async {
    if (state.posts.isEmpty) emit(const FeedState());
    try {
      emit(
        FeedState(status: FeedStatus.loaded, posts: await _repository.feed()),
      );
    } catch (_) {
      emit(FeedState(status: FeedStatus.failure, posts: state.posts));
    }
  }
}
