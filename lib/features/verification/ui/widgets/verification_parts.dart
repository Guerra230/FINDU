import 'package:flutter/material.dart';

import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/models/post.dart';
import 'package:findu/features/posts/ui/widgets/post_loader.dart';
import 'package:findu/features/verification/domain/verification_repository.dart';

class VerificationOutcome {
  const VerificationOutcome({
    required this.post,
    required this.result,
    required this.questions,
  });

  final Post post;
  final VerificationResult result;
  final List<VerificationQuestion> questions;
}

class PostSummaryRow extends StatelessWidget {
  const PostSummaryRow({
    super.key,
    required this.post,
    this.trailing,
    this.subtitle,
  });

  final Post post;
  final Widget? trailing;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return FdListRow(
      leading: PostThumb(post: post),
      title: post.title,
      subtitle: subtitle ?? 'Publicado por ${post.authorName}',
      trailing: trailing,
    );
  }
}

class ResultBody extends StatelessWidget {
  const ResultBody({
    super.key,
    required this.hero,
    required this.children,
    required this.actions,
  });

  final Widget hero;
  final List<Widget> children;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FdColors.background,
      body: Column(
        children: [
          hero,
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(FdSpacing.screen),
              children: children,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              FdSpacing.screen,
              0,
              FdSpacing.screen,
              FdSpacing.md,
            ),
            child: SafeArea(
              top: false,
              child: Column(mainAxisSize: MainAxisSize.min, children: actions),
            ),
          ),
        ],
      ),
    );
  }
}
