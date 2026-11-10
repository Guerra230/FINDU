import 'dart:typed_data';

import 'package:findu/core/models/post.dart';

class NewQuestion {
  const NewQuestion({required this.text, required this.answer});

  final String text;
  final String answer;
}

class NewPost {
  const NewPost({
    required this.kind,
    required this.intent,
    required this.title,
    required this.category,
    required this.place,
    required this.photos,
    this.description,
    this.reward,
    this.petName,
    this.breed,
    this.questions = const [],
  });

  final PostKind kind;
  final PostIntent intent;
  final String title;
  final String category;
  final String place;
  final List<Uint8List> photos;
  final String? description;
  final int? reward;
  final String? petName;
  final String? breed;
  final List<NewQuestion> questions;
}

abstract interface class PostsRepository {
  Future<List<Post>> feed();

  Future<List<Post>> mine();

  Future<Post> byId(String id);

  Future<String> create(NewPost post);
}
