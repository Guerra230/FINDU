import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/features/chat/domain/chat_models.dart';
import 'package:findu/features/chat/domain/chat_repository.dart';
import 'package:findu/features/chat/ui/bloc/chat_cubit.dart';

class DeliveryProblemScreen extends StatelessWidget {
  const DeliveryProblemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final conversation =
        ModalRoute.of(context)!.settings.arguments! as Conversation;
    return BlocProvider(
      create: (context) => DeliveryProblemCubit(context.read<ChatRepository>()),
      child: _ProblemView(conversation: conversation),
    );
  }
}

class _ProblemView extends StatefulWidget {
  const _ProblemView({required this.conversation});

  final Conversation conversation;

  @override
  State<_ProblemView> createState() => _ProblemViewState();
}

class _ProblemViewState extends State<_ProblemView> {
  String? _reason;
  final _detail = TextEditingController();

  static const _reasons = [
    FdOption(value: 'no_era', title: 'No era la mascota u objeto correcto'),
    FdOption(value: 'no_llego', title: 'La otra persona no llegó al encuentro'),
    FdOption(
      value: 'sin_acuerdo',
      title: 'No nos pusimos de acuerdo para vernos',
    ),
    FdOption(value: 'otro', title: 'Otro motivo'),
  ];

  @override
  void dispose() {
    _detail.dispose();
    super.dispose();
  }

  void _onState(BuildContext context, ProblemStatus status) {
    if (status == ProblemStatus.sent) {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.problemSent,
        arguments: widget.conversation,
      );
    }
    if (status == ProblemStatus.failure) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No pudimos enviar el reporte. Intenta de nuevo.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeliveryProblemCubit, ProblemStatus>(
      listener: _onState,
      builder: (context, status) => FdScaffold(
        body: Column(
          children: [
            const FdScreenHeader(title: 'Reportar problema'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  FdSpacing.screen,
                  FdSpacing.xs,
                  FdSpacing.screen,
                  FdSpacing.lg,
                ),
                children: [
                  Text('¿Qué pasó con la entrega?', style: FdTypography.h1),
                  const SizedBox(height: FdSpacing.xs),
                  Text(
                    'Tu reporte no cierra la publicación. Elige el motivo:',
                    style: FdTypography.body.copyWith(
                      color: FdColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: FdSpacing.md),
                  FdOptionCards<String>(
                    options: _reasons,
                    selected: _reason,
                    onChanged: (v) => setState(() => _reason = v),
                  ),
                  FdTextField(
                    label: 'Cuéntanos qué pasó (opcional)',
                    controller: _detail,
                    maxLines: 3,
                  ),
                  const SizedBox(height: FdSpacing.md),
                  const FdInfoNote(
                    message:
                        'La publicación vuelve a estar activa y la recompensa sigue retenida. El chat sigue abierto para acordar otro encuentro.',
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
                label: 'Enviar reporte',
                isLoading: status == ProblemStatus.sending,
                onPressed: _reason == null
                    ? null
                    : () => context.read<DeliveryProblemCubit>().send(
                        widget.conversation.id,
                        reason: _reason!,
                        detail: _detail.text,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
