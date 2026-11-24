import 'package:findu/core/models/post.dart';
import 'package:findu/features/posts/domain/posts_repository.dart';

class ObtenerFeed {
  const ObtenerFeed(this._repository);

  final PostsRepository _repository;

  Future<List<Post>> call() => _repository.feed();
}

class ObtenerMisPublicaciones {
  const ObtenerMisPublicaciones(this._repository);

  final PostsRepository _repository;

  Future<List<Post>> call() => _repository.mine();
}

class ObtenerPublicacion {
  const ObtenerPublicacion(this._repository);

  final PostsRepository _repository;

  Future<Post> call(String id) => _repository.byId(id);
}

class PublicacionInvalida implements Exception {
  const PublicacionInvalida(this.message);

  final String message;
}

class CrearPublicacion {
  const CrearPublicacion(this._repository);

  final PostsRepository _repository;

  Future<String> call(NewPost post) {
    if (post.photos.isEmpty) {
      throw const PublicacionInvalida('Agrega al menos una foto');
    }
    if (post.title.trim().isEmpty) {
      throw const PublicacionInvalida('Escribe un título');
    }
    if (post.intent == PostIntent.found) {
      final completas = post.questions.where(
        (q) => q.text.trim().isNotEmpty && q.answer.trim().isNotEmpty,
      );
      if (completas.length < 3) {
        throw const PublicacionInvalida(
          'Escribe las 3 preguntas con su respuesta',
        );
      }
    }
    if (post.reward != null && post.intent == PostIntent.found) {
      throw const PublicacionInvalida('Solo lo perdido puede tener recompensa');
    }
    return _repository.create(post);
  }
}
