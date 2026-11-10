import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/models/post.dart';
import 'package:findu/features/posts/domain/posts_repository.dart';
import 'package:findu/features/posts/ui/bloc/feed_bloc.dart';

class FeedScope extends StatelessWidget {
  const FeedScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          FeedBloc(context.read<PostsRepository>())..add(const FeedRequested()),
      child: child,
    );
  }
}

class FeedBuilder extends StatelessWidget {
  const FeedBuilder({super.key, required this.builder});

  final Widget Function(BuildContext context, List<Post> posts) builder;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedBloc, FeedState>(
      builder: (context, state) {
        if (state.status == FeedStatus.loading) {
          return const Padding(
            padding: EdgeInsets.all(FdSpacing.xl),
            child: FdLoadingState(),
          );
        }
        if (state.status == FeedStatus.failure && state.posts.isEmpty) {
          return FdErrorState(
            message: 'No pudimos cargar las publicaciones.',
            onRetry: () => context.read<FeedBloc>().add(const FeedRequested()),
          );
        }
        return builder(context, state.posts);
      },
    );
  }
}
