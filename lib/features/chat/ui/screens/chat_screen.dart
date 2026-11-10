import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/core/utils/formatters.dart';
import 'package:findu/features/chat/domain/chat_models.dart';
import 'package:findu/features/chat/domain/chat_repository.dart';
import 'package:findu/features/chat/ui/bloc/chat_cubit.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final id = routeId(context);
    if (id == null) {
      return FdScaffold(
        body: Center(
          child: FdErrorState(
            message: 'Chat no encontrado.',
            onRetry: () => Navigator.maybePop(context),
          ),
        ),
      );
    }
    return BlocProvider(
      create: (context) =>
          ChatCubit(context.read<ChatRepository>(), id)..load(),
      child: const _ChatView(),
    );
  }
}

class _ChatView extends StatefulWidget {
  const _ChatView();

  @override
  State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  final _input = TextEditingController();
  final _scroll = ScrollController();

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _send() async {
    final text = _input.text;
    if (text.trim().isEmpty) return;
    _input.clear();
    final ok = await context.read<ChatCubit>().send(text);
    if (!ok && mounted) _input.text = text;
  }

  void _confirmDelivery(ChatState state) {
    final cubit = context.read<ChatCubit>();
    final conversation = state.conversation!;
    showFdBottomSheet<void>(
      context,
      builder: (sheetContext) => FdSheetContent(
        title: '¿Cómo salió la entrega?',
        message:
            'Ambos deben confirmar. Cuando los dos confirman, la publicación se cierra y la recompensa se libera.',
        note: state.otherConfirmed
            ? '${conversation.otherFirstName} ya confirmó la entrega'
            : null,
        primaryLabel: 'Sí, la entrega se hizo',
        onPrimary: () {
          Navigator.pop(sheetContext);
          cubit.confirmDelivery();
        },
        secondaryLabel: 'No, hubo un problema',
        secondaryIsDanger: true,
        onSecondary: () {
          Navigator.pop(sheetContext);
          Navigator.pushNamed(
            context,
            AppRoutes.deliveryProblem,
            arguments: conversation,
          );
        },
      ),
    );
  }

  void _onState(BuildContext context, ChatState state) {
    if (state.error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.error!)));
    }
    if (state.delivery.state == DeliveryState.confirmed &&
        state.conversation != null) {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.deliveryVerified,
        arguments: state.conversation,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listenWhen: (a, b) =>
          a.error != b.error || a.delivery.state != b.delivery.state,
      listener: _onState,
      builder: (context, state) {
        if (state.status == ChatStatus.loading) {
          return const FdScaffold(body: FdLoadingState());
        }
        if (state.status == ChatStatus.failure) {
          return FdScaffold(
            body: Column(
              children: [
                const FdScreenHeader(title: 'Chat'),
                Expanded(
                  child: Center(
                    child: FdErrorState(
                      message: 'No pudimos abrir el chat.',
                      onRetry: context.read<ChatCubit>().load,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        _scrollToEnd();
        return _buildChat(context, state);
      },
    );
  }

  Widget _buildChat(BuildContext context, ChatState state) {
    final conversation = state.conversation!;
    final post = conversation.post;

    return FdScaffold(
      body: Column(
        children: [
          SizedBox(
            height: FdScreenHeader.height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: FdSpacing.md),
              child: Row(
                children: [
                  FdIconButton(
                    icon: Icons.chevron_left_rounded,
                    tooltip: 'Atrás',
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  const SizedBox(width: FdSpacing.sm),
                  FdAvatar(name: conversation.otherName, size: 40),
                  const SizedBox(width: FdSpacing.sm),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          conversation.otherName,
                          style: FdTypography.bodyStrong,
                        ),
                        Text(post.title, style: FdTypography.caption),
                      ],
                    ),
                  ),
                  FdIconButton(
                    icon: Icons.info_outline_rounded,
                    tooltip: 'Ver publicación',
                    onPressed: () => Navigator.pushNamed(
                      context,
                      AppRoutes.postDetail,
                      arguments: post.id,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              controller: _scroll,
              padding: const EdgeInsets.fromLTRB(
                FdSpacing.screen,
                0,
                FdSpacing.screen,
                FdSpacing.md,
              ),
              children: [
                Center(
                  child: Text(
                    '${timeAgo(conversation.openedAt)} · chat abierto automáticamente',
                    style: FdTypography.caption,
                  ),
                ),
                const SizedBox(height: FdSpacing.sm),
                FdGlass(
                  strong: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(post.icon, color: FdColors.primary, size: 18),
                          const SizedBox(width: FdSpacing.xs),
                          Expanded(
                            child: Text(
                              conversation.summary,
                              style: FdTypography.bodyStrong,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: FdSpacing.sm),
                      Wrap(
                        spacing: FdSpacing.xs,
                        runSpacing: FdSpacing.xs,
                        children: [
                          FdTag(label: post.title),
                          FdTag(label: post.place),
                          if (post.reward != null)
                            FdTag(
                              label: 'Recompensa ${formatCop(post.reward!)}',
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: FdSpacing.md),
                for (final message in state.messages) _Bubble(message: message),
                const SizedBox(height: FdSpacing.sm),
                if (state.iConfirmed && !state.otherConfirmed)
                  FdInfoNote(
                    icon: Icons.hourglass_top_rounded,
                    message:
                        'Confirmaste la entrega. Falta que ${conversation.otherFirstName} confirme.',
                  )
                else if (state.delivery.state == DeliveryState.problem)
                  const FdInfoNote(
                    icon: Icons.report_outlined,
                    message:
                        'Se reportó un problema con la entrega. Pueden acordar otro encuentro.',
                  )
                else
                  const FdInfoNote(
                    message:
                        'Acuerden aquí dónde y cuándo verse. Elijan un lugar público.',
                  ),
              ],
            ),
          ),
          if (conversation.open)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                FdSpacing.screen,
                FdSpacing.xs,
                FdSpacing.screen,
                0,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: FdButton(
                      label: state.iConfirmed
                          ? 'Ya confirmaste'
                          : 'Confirmar entrega',
                      isLoading: state.confirming,
                      onPressed: state.iConfirmed
                          ? null
                          : () => _confirmDelivery(state),
                    ),
                  ),
                  const SizedBox(width: FdSpacing.sm),
                  Expanded(
                    flex: 2,
                    child: FdButton(
                      label: 'Hubo un problema',
                      variant: FdButtonVariant.danger,
                      onPressed: () => Navigator.pushNamed(
                        context,
                        AppRoutes.deliveryProblem,
                        arguments: conversation,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              FdSpacing.screen,
              FdSpacing.sm,
              FdSpacing.screen,
              FdSpacing.md,
            ),
            child: conversation.open
                ? Row(
                    children: [
                      Expanded(
                        child: FdGlass(
                          strong: true,
                          radius: FdRadius.pill,
                          padding: const EdgeInsets.symmetric(
                            horizontal: FdSpacing.md,
                          ),
                          child: TextField(
                            controller: _input,
                            onSubmitted: (_) => _send(),
                            textInputAction: TextInputAction.send,
                            style: FdTypography.body,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Escribe un mensaje…',
                              hintStyle: FdTypography.body.copyWith(
                                color: FdColors.textDisabled,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: FdSpacing.sm),
                      FdIconButton(
                        icon: Icons.send_rounded,
                        filled: true,
                        tooltip: 'Enviar',
                        onPressed: _send,
                      ),
                    ],
                  )
                : Text(
                    'Este chat se cerró porque la entrega se completó.',
                    style: FdTypography.caption,
                  ),
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final mine = message.mine;
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.72,
        ),
        margin: const EdgeInsets.only(bottom: FdSpacing.xs),
        padding: const EdgeInsets.symmetric(
          horizontal: FdSpacing.md,
          vertical: FdSpacing.sm,
        ),
        decoration: BoxDecoration(
          gradient: mine ? FdGradients.button : null,
          color: mine ? null : FdColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(FdRadius.md),
            topRight: const Radius.circular(FdRadius.md),
            bottomLeft: Radius.circular(mine ? FdRadius.md : FdSpacing.xxs),
            bottomRight: Radius.circular(mine ? FdSpacing.xxs : FdRadius.md),
          ),
          border: mine ? null : Border.all(color: FdColors.border),
        ),
        child: Column(
          crossAxisAlignment: mine
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: FdTypography.body.copyWith(
                color: mine ? FdColors.onPrimary : FdColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              shortTime(message.sentAt),
              style: FdTypography.caption.copyWith(
                fontSize: 11,
                color: mine
                    ? FdColors.onPrimary.withValues(alpha: 0.8)
                    : FdColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
