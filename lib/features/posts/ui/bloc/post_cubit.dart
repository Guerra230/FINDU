import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:findu/core/models/post.dart';
import 'package:findu/features/posts/domain/posts_repository.dart';

sealed class PostState {
  const PostState();
}

final class PostLoading extends PostState {
  const PostLoading();
}

final class PostLoaded extends PostState {
  const PostLoaded(this.post);

  final Post post;
}

final class PostFailure extends PostState {
  const PostFailure();
}

class PostCubit extends Cubit<PostState> {
  PostCubit(this._repository) : super(const PostLoading());

  final PostsRepository _repository;

  Future<void> load(String? id) async {
    if (id == null) {
      emit(const PostFailure());
      return;
    }
    emit(const PostLoading());
    try {
      emit(PostLoaded(await _repository.byId(id)));
    } catch (_) {
      emit(const PostFailure());
    }
  }
}

class MyPostsCubit extends Cubit<List<Post>?> {
  MyPostsCubit(this._repository) : super(null);

  final PostsRepository _repository;

  Future<void> load() async {
    try {
      emit(await _repository.mine());
    } catch (_) {
      emit(const []);
    }
  }
}
