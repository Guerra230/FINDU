import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/models/post.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/core/utils/formatters.dart';
import 'package:findu/features/posts/ui/widgets/post_loader.dart';
import 'package:findu/features/verification/domain/verification_repository.dart';
import 'package:findu/features/verification/ui/bloc/verification_cubit.dart';
import 'package:findu/features/verification/ui/widgets/verification_parts.dart';

class VerificationQuestionScreen extends StatelessWidget {
  const VerificationQuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final postId = routeId(context);
    return PostLoader(
      postId: postId,
      builder: (context, post) => BlocProvider(
        create: (context) =>
            VerificationCubit(context.read<VerificationRepository>(), post.id)
              ..load(),
        child: _QuestionView(post: post),
      ),
    );
  }
}

class _QuestionView extends StatefulWidget {
  const _QuestionView({required this.post});

  final Post post;

  @override
  State<_QuestionView> createState() => _QuestionViewState();
}

class _QuestionViewState extends State<_QuestionView> {
  final _answer = TextEditingController();
  int? _shownIndex;

  @override
  void dispose() {
    _answer.dispose();
    super.dispose();
  }

  void _onState(BuildContext context, VerificationState state) {
    if (state.error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.error!)));
    }
    final result = state.result;
    if (state.status == VerificationStatus.finished && result != null) {
      Navigator.pushReplacementNamed(
        context,
        result.approved
            ? AppRoutes.verificationApproved
            : AppRoutes.verificationFailed,
        arguments: VerificationOutcome(
          post: widget.post,
          result: result,
          questions: state.questions,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<VerificationCubit>();
    return BlocConsumer<VerificationCubit, VerificationState>(
      listenWhen: (a, b) => a.status != b.status || a.error != b.error,
      listener: _onState,
      buildWhen: (a, b) => a.index != b.index || a.status != b.status,
      builder: (context, state) {
        if (state.status == VerificationStatus.loading) {
          return const FdScaffold(body: FdLoadingState());
        }
        if (state.status == VerificationStatus.failure) {
          return FdScaffold(
            body: Column(
              children: [
                const FdScreenHeader(title: 'Verificación'),
                Expanded(
                  child: Center(
                    child: FdErrorState(
                      message: state.error ?? '',
                      onRetry: cubit.load,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        if (_shownIndex != state.index) {
          _shownIndex = state.index;
          _answer.text = state.currentAnswer;
        }
        final total = state.questions.length;
        return PopScope(
          canPop: state.index == 0,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) cubit.back();
          },
          child: FdScaffold(
            body: Column(
              children: [
                const FdScreenHeader(title: 'Verificación'),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(
                      FdSpacing.screen,
                      FdSpacing.xs,
                      FdSpacing.screen,
                      FdSpacing.lg,
                    ),
                    children: [
                      PostSummaryRow(post: widget.post),
                      const SizedBox(height: FdSpacing.md),
                      FdSteps(current: state.index + 1, total: total),
                      const SizedBox(height: FdSpacing.md),
                      Container(
                        constraints: const BoxConstraints(minHeight: 200),
                        padding: const EdgeInsets.all(FdSpacing.lg),
                        decoration: BoxDecoration(
                          gradient: FdGradients.hero,
                          borderRadius: BorderRadius.circular(FdRadius.lg),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PREGUNTA ${state.index + 1} DE $total',
                              style: FdTypography.overline,
                            ),
                            const SizedBox(height: FdSpacing.sm),
                            Text(
                              state.questions[state.index].text,
                              style: FdTypography.h1,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: FdSpacing.md),
                      FdTextField(
                        key: ValueKey(state.index),
                        label: 'Tu respuesta',
                        controller: _answer,
                        onChanged: (v) {
                          cubit.answer(v);
                          setState(() {});
                        },
                        textInputAction: TextInputAction.done,
                      ),
                      const SizedBox(height: FdSpacing.sm),
                      Text(
                        'Las respuestas solo las ve quien publica. No compartimos tu contacto.',
                        textAlign: TextAlign.center,
                        style: FdTypography.caption,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    FdSpacing.screen,
                    0,
                    FdSpacing.screen,
                    FdSpacing.md,
                  ),
                  child: FdButton(
                    label: state.isLast ? 'Enviar respuestas' : 'Siguiente',
                    isLoading: state.status == VerificationStatus.sending,
                    onPressed: _answer.text.trim().isEmpty ? null : cubit.next,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
