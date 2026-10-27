import 'package:flutter/material.dart';

import 'package:findu/core/demo/demo_visuals.dart';
import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/features/chat/ui/widgets/chat_data.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  late ChatInfo _info;
  late List<ChatMessage> _messages;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    _info = ChatInfo.of(routeId(context));
    _messages = [..._info.messages];
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send() {
    final text = _input.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(ChatMessage(text: text, mine: true));
      _input.clear();
    });
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

  void _confirmDelivery() {
    final post = _info.post;
    showFdBottomSheet<void>(
      context,
      builder: (sheetContext) => FdSheetContent(
        title: '¿Cómo salió la entrega?',
        message: 'Ambos deben confirmar. Cuando los dos confirman, la publicación se cierra y la recompensa se libera.',
        note: '${_info.person} ya confirmó la entrega',
        primaryLabel: 'Sí, la entrega se hizo',
        onPrimary: () {
          Navigator.pop(sheetContext);
          Navigator.pushReplacementNamed(context, AppRoutes.deliveryVerified, arguments: post.id);
        },
        secondaryLabel: 'No, hubo un problema',
        secondaryIsDanger: true,
        onSecondary: () {
          Navigator.pop(sheetContext);
          Navigator.pushNamed(context, AppRoutes.deliveryProblem, arguments: post.id);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final post = _info.post;

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
                  FdAvatar(name: _info.person, size: 40),
                  const SizedBox(width: FdSpacing.sm),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_info.person, style: FdTypography.bodyStrong),
                        Row(
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(color: FdColors.success, shape: BoxShape.circle),
                            ),
                            const SizedBox(width: FdSpacing.xxs),
                            Text('En línea', style: FdTypography.caption),
                          ],
                        ),
                      ],
                    ),
                  ),
                  FdIconButton(
                    icon: Icons.info_outline_rounded,
                    tooltip: 'Ver publicación',
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.postDetail, arguments: post.id),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              controller: _scroll,
              padding: const EdgeInsets.fromLTRB(FdSpacing.screen, 0, FdSpacing.screen, FdSpacing.md),
              children: [
                Center(child: Text('Hoy · chat abierto automáticamente', style: FdTypography.caption)),
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
                          Expanded(child: Text(_info.context, style: FdTypography.bodyStrong)),
                        ],
                      ),
                      const SizedBox(height: FdSpacing.sm),
                      Wrap(
                        spacing: FdSpacing.xs,
                        runSpacing: FdSpacing.xs,
                        children: [
                          FdTag(label: post.title),
                          FdTag(label: post.place),
                          if (post.reward != null) FdTag(label: 'Recompensa ${formatCop(post.reward!)}'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: FdSpacing.md),
                for (final message in _messages) _Bubble(message: message),
                const SizedBox(height: FdSpacing.sm),
                const FdInfoNote(message: 'Acuerden aquí dónde y cuándo verse. Elijan un lugar público.'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(FdSpacing.screen, FdSpacing.xs, FdSpacing.screen, 0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: FdButton(label: 'Confirmar entrega', onPressed: _confirmDelivery),
                ),
                const SizedBox(width: FdSpacing.sm),
                Expanded(
                  flex: 2,
                  child: FdButton(
                    label: 'Hubo un problema',
                    variant: FdButtonVariant.danger,
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.deliveryProblem, arguments: post.id),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(FdSpacing.screen, FdSpacing.sm, FdSpacing.screen, FdSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: FdGlass(
                    strong: true,
                    radius: FdRadius.pill,
                    padding: const EdgeInsets.symmetric(horizontal: FdSpacing.md),
                    child: TextField(
                      controller: _input,
                      onSubmitted: (_) => _send(),
                      textInputAction: TextInputAction.send,
                      style: FdTypography.body,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Escribe un mensaje…',
                        hintStyle: FdTypography.body.copyWith(color: FdColors.textDisabled),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: FdSpacing.sm),
                FdIconButton(icon: Icons.send_rounded, filled: true, tooltip: 'Enviar', onPressed: _send),
              ],
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
        constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.72),
        margin: const EdgeInsets.only(bottom: FdSpacing.xs),
        padding: const EdgeInsets.symmetric(horizontal: FdSpacing.md, vertical: FdSpacing.sm),
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
        child: Text(
          message.text,
          style: FdTypography.body.copyWith(color: mine ? FdColors.onPrimary : FdColors.textPrimary),
        ),
      ),
    );
  }
}
