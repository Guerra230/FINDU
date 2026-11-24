import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:findu/features/posts/domain/posts_repository.dart';
import 'package:findu/features/posts/domain/usecases/posts_usecases.dart';

enum PublishStatus { editing, sending, done, failure }

class PublishState {
  const PublishState({
    this.status = PublishStatus.editing,
    this.postId,
    this.error,
  });

  final PublishStatus status;
  final String? postId;
  final String? error;
}

class PublishCubit extends Cubit<PublishState> {
  PublishCubit(this._crearPublicacion) : super(const PublishState());

  final CrearPublicacion _crearPublicacion;

  Future<void> publish(NewPost post) async {
    emit(const PublishState(status: PublishStatus.sending));
    try {
      final id = await _crearPublicacion(post);
      emit(PublishState(status: PublishStatus.done, postId: id));
    } on PublicacionInvalida catch (e) {
      emit(PublishState(status: PublishStatus.failure, error: e.message));
    } catch (_) {
      emit(
        const PublishState(
          status: PublishStatus.failure,
          error: 'No pudimos publicar. Revisa tu conexión e intenta de nuevo.',
        ),
      );
    }
  }
}
