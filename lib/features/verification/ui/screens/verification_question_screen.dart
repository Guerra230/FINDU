import 'package:flutter/material.dart';

import 'package:findu/core/demo/demo_data.dart';
import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/features/verification/ui/widgets/verification_parts.dart';

class VerificationQuestionScreen extends StatefulWidget {
  const VerificationQuestionScreen({super.key});

  @override
  State<VerificationQuestionScreen> createState() => _VerificationQuestionScreenState();
}

class _VerificationQuestionScreenState extends State<VerificationQuestionScreen> {
  final _answer = TextEditingController();

  @override
  void dispose() {
    _answer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final raw = ModalRoute.of(context)?.settings.arguments;
    final args = raw is VerificationArgs ? raw : VerificationArgs(postId: DemoData.posts[2].id, index: 0);
    final post = DemoData.post(args.postId);
    final total = post.questions.isEmpty ? 3 : post.questions.length;
    final question = post.questions.isEmpty ? 'Pregunta ${args.index + 1}' : post.questions[args.index];
    final isLast = args.index >= total - 1;

    void next() {
      if (!isLast) {
        Navigator.pushNamed(
          context,
          AppRoutes.verificationQuestion,
          arguments: VerificationArgs(postId: post.id, index: args.index + 1),
        );
        return;
      }
      final approved = post.id != 'billetera';
      Navigator.pushNamedAndRemoveUntil(
        context,
        approved ? AppRoutes.verificationApproved : AppRoutes.verificationFailed,
        (route) => route.settings.name == AppRoutes.postDetail || route.isFirst,
        arguments: post.id,
      );
    }

    return FdScaffold(
      body: Column(
        children: [
          const FdScreenHeader(title: 'Verificación'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(FdSpacing.screen, FdSpacing.xs, FdSpacing.screen, FdSpacing.lg),
              children: [
                PostSummaryRow(post: post),
                const SizedBox(height: FdSpacing.md),
                FdSteps(current: args.index + 1, total: total),
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
                      Text('PREGUNTA ${args.index + 1} DE $total', style: FdTypography.overline),
                      const SizedBox(height: FdSpacing.sm),
                      Text(question, style: FdTypography.h1),
                    ],
                  ),
                ),
                const SizedBox(height: FdSpacing.md),
                FdTextField(
                  label: 'Tu respuesta',
                  controller: _answer,
                  onChanged: (_) => setState(() {}),
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
            padding: const EdgeInsets.fromLTRB(FdSpacing.screen, 0, FdSpacing.screen, FdSpacing.md),
            child: FdButton(
              label: isLast ? 'Enviar respuestas' : 'Siguiente',
              onPressed: _answer.text.trim().isEmpty ? null : next,
            ),
          ),
        ],
      ),
    );
  }
}
