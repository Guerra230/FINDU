import 'package:flutter/material.dart';

import 'package:findu/core/demo/demo_data.dart';
import 'package:findu/core/demo/demo_visuals.dart';
import 'package:findu/core/design_system/design_system.dart';

class VerificationArgs {
  const VerificationArgs({required this.postId, required this.index});

  final String postId;
  final int index;
}

class PostSummaryRow extends StatelessWidget {
  const PostSummaryRow({super.key, required this.post, this.trailing, this.subtitle});

  final DemoPost post;
  final Widget? trailing;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return FdListRow(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: FdColors.primarySoft,
          borderRadius: BorderRadius.circular(FdRadius.sm),
        ),
        child: Icon(post.icon, color: FdColors.primary),
      ),
      title: post.title,
      subtitle: subtitle ?? 'Publicado por ${post.author}',
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
            padding: const EdgeInsets.fromLTRB(FdSpacing.screen, 0, FdSpacing.screen, FdSpacing.md),
            child: SafeArea(top: false, child: Column(mainAxisSize: MainAxisSize.min, children: actions)),
          ),
        ],
      ),
    );
  }
}
