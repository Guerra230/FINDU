import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:findu/core/di/inyeccion.dart';
import 'package:findu/core/models/post.dart';
import 'package:findu/features/posts/domain/posts_repository.dart';
import 'package:findu/features/posts/domain/usecases/posts_usecases.dart';
import 'package:findu/features/posts/posts_di.dart';
import 'package:findu/features/posts/ui/bloc/feed_bloc.dart';
import 'package:findu/features/publish/ui/bloc/publish_cubit.dart';

class FakePostsRepository implements PostsRepository {
  final created = <NewPost>[];
  bool fail = false;
  List<Post> posts = [];

  @override
  Future<String> create(NewPost post) async {
    if (fail) throw Exception('sin conexión');
    created.add(post);
    return 'post-1';
  }

  @override
  Future<List<Post>> feed() async => posts;

  @override
  Future<List<Post>> mine() async => posts;

  @override
  Future<Post> byId(String id) async => posts.firstWhere((p) => p.id == id);
}

NewPost objetoEncontrado({List<Uint8List>? photos, int preguntas = 3}) =>
    NewPost(
      kind: PostKind.object,
      intent: PostIntent.found,
      title: 'Mochila azul',
      category: 'Mochila',
      place: 'Biblioteca',
      photos:
          photos ??
          [
            Uint8List.fromList([1, 2, 3]),
          ],
      questions: [
        for (var i = 0; i < preguntas; i++)
          NewQuestion(text: 'Pregunta $i', answer: 'Respuesta $i'),
      ],
    );

Post publicacion(String id) => Post(
  id: id,
  title: 'Termo',
  kind: PostKind.object,
  intent: PostIntent.found,
  category: 'Termo',
  place: 'Biblioteca',
  createdAt: DateTime(2026, 11, 24),
  authorId: 'u1',
  authorName: 'Juan',
  state: 'activa',
  latitude: 3.34,
  longitude: -76.53,
);

void main() {
  late FakePostsRepository repository;

  setUp(() async {
    await sl.reset();
    repository = FakePostsRepository();
    sl.registerLazySingleton<PostsRepository>(() => repository);
    registrarPosts(sl);
  });

  test('GetIt entrega el PublishCubit con el repositorio falso', () async {
    final cubit = sl<PublishCubit>();
    final estados = <PublishStatus>[];
    final sub = cubit.stream.listen((s) => estados.add(s.status));

    await cubit.publish(objetoEncontrado());
    await Future<void>.delayed(Duration.zero);

    expect(estados, [PublishStatus.sending, PublishStatus.done]);
    expect(cubit.state.postId, 'post-1');
    expect(repository.created, hasLength(1));
    await sub.cancel();
    await cubit.close();
  });

  test(
    'publicar sin fotos falla con mensaje y no llama al repositorio',
    () async {
      final cubit = sl<PublishCubit>();

      await cubit.publish(objetoEncontrado(photos: []));

      expect(cubit.state.status, PublishStatus.failure);
      expect(cubit.state.error, 'Agrega al menos una foto');
      expect(repository.created, isEmpty);
      await cubit.close();
    },
  );

  test('un objeto encontrado necesita 3 preguntas', () {
    expect(
      () => sl<CrearPublicacion>()(objetoEncontrado(preguntas: 2)),
      throwsA(isA<PublicacionInvalida>()),
    );
  });

  test('si el repositorio falla el cubit queda en failure', () async {
    repository.fail = true;
    final cubit = sl<PublishCubit>();

    await cubit.publish(objetoEncontrado());

    expect(cubit.state.status, PublishStatus.failure);
    await cubit.close();
  });

  test('FeedBloc carga las publicaciones del repositorio', () async {
    repository.posts = [publicacion('a'), publicacion('b')];
    final bloc = sl<FeedBloc>()..add(const FeedRequested());

    final estado = await bloc.stream.firstWhere(
      (s) => s.status == FeedStatus.loaded,
    );

    expect(estado.posts.map((p) => p.id), ['a', 'b']);
    await bloc.close();
  });
}
