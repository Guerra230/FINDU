import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/models/post.dart';
import 'package:findu/features/posts/domain/posts_repository.dart';
import 'package:findu/features/posts/ui/bloc/post_cubit.dart';

class PostLoader extends StatelessWidget {
  const PostLoader({super.key, required this.postId, required this.builder});

  final String? postId;
  final Widget Function(BuildContext context, Post post) builder;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PostCubit(context.read<PostsRepository>())..load(postId),
      child: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) => switch (state) {
          PostLoaded(:final post) => builder(context, post),
          PostLoading() => const FdScaffold(body: FdLoadingState()),
          PostFailure() => FdScaffold(
            body: Column(
              children: [
                const FdScreenHeader(title: 'Publicación'),
                Expanded(
                  child: Center(
                    child: FdErrorState(
                      message:
                          'No encontramos esta publicación o ya no está disponible.',
                      onRetry: () => context.read<PostCubit>().load(postId),
                    ),
                  ),
                ),
              ],
            ),
          ),
        },
      ),
    );
  }
}

class PostThumb extends StatelessWidget {
  const PostThumb({super.key, required this.post, this.size = 48});

  final Post post;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: FdColors.primarySoft,
        borderRadius: BorderRadius.circular(FdRadius.sm),
        image: post.image == null
            ? null
            : DecorationImage(image: post.image!, fit: BoxFit.cover),
      ),
      child: post.image == null
          ? Icon(post.icon, color: FdColors.primary, size: size * 0.5)
          : null,
    );
  }
}
