import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/models/post.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/core/navigation/main_shell.dart';
import 'package:findu/core/utils/formatters.dart';
import 'package:findu/features/chat/domain/chat_models.dart';
import 'package:findu/features/chat/domain/chat_repository.dart';
import 'package:findu/features/chat/ui/bloc/chats_cubit.dart';

enum _ChatFilter { all, unread, objects, pets }

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatsCubit(context.read<ChatRepository>())..load(),
      child: const _ChatsView(),
    );
  }
}

class _ChatsView extends StatefulWidget {
  const _ChatsView();

  @override
  State<_ChatsView> createState() => _ChatsViewState();
}

class _ChatsViewState extends State<_ChatsView> {
  _ChatFilter _filter = _ChatFilter.all;
  String _query = '';

  Future<void> _open(Conversation chat) async {
    final cubit = context.read<ChatsCubit>();
    await Navigator.pushNamed(context, AppRoutes.chat, arguments: chat.id);
    cubit.load();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ChatsCubit>().state;
    final query = _query.trim().toLowerCase();
    final chats = state.conversations.where((c) {
      final matches =
          query.isEmpty ||
          '${c.otherName} ${c.post.title}'.toLowerCase().contains(query);
      final passesFilter = switch (_filter) {
        _ChatFilter.all => true,
        _ChatFilter.unread => c.unread,
        _ChatFilter.objects => !c.post.isPet,
        _ChatFilter.pets => c.post.isPet,
      };
      return matches && passesFilter;
    }).toList();

    return FdBackground(
      child: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: context.read<ChatsCubit>().load,
          child: ListView(
            padding: const EdgeInsets.only(bottom: 120),
            children: [
              const FdLargeTitle(title: 'Chats'),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: FdSpacing.screen,
                ),
                child: FdTextField(
                  label: 'Buscar',
                  hint: 'Chats u objetos',
                  onChanged: (v) => setState(() => _query = v),
                ),
              ),
              const SizedBox(height: FdSpacing.sm),
              FdChipBar<_ChatFilter>(
                options: const {
                  _ChatFilter.all: 'Todos',
                  _ChatFilter.unread: 'Sin leer',
                  _ChatFilter.objects: 'Objetos',
                  _ChatFilter.pets: 'Mascotas',
                },
                selected: _filter,
                onChanged: (v) => setState(() => _filter = v),
              ),
              const SizedBox(height: FdSpacing.sm),
              if (state.status == ChatsStatus.loading)
                const FdLoadingState()
              else if (state.status == ChatsStatus.failure && chats.isEmpty)
                FdErrorState(
                  message: 'No pudimos cargar tus chats.',
                  onRetry: context.read<ChatsCubit>().load,
                )
              else if (chats.isEmpty)
                FdEmptyState(
                  mood: FdMood.esperando,
                  title: 'Aún no tienes chats',
                  message:
                      'Un chat se abre cuando verificas que algo es tuyo o cuando reportas que encontraste algo.',
                  actionLabel: 'Explorar',
                  onAction: () => MainShell.goTo(context, AppTabs.explore),
                )
              else
                for (final chat in chats)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      FdSpacing.screen,
                      0,
                      FdSpacing.screen,
                      FdSpacing.sm,
                    ),
                    child: _ChatRow(chat: chat, onTap: () => _open(chat)),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

String _kindLabel(Post post) {
  if (post.isPet) return post.isLost ? 'mascota perdida' : 'mascota encontrada';
  return post.isLost ? 'objeto perdido' : 'objeto encontrado';
}

class _ChatRow extends StatelessWidget {
  const _ChatRow({required this.chat, required this.onTap});

  final Conversation chat;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final last = chat.lastMessage;
    return FdGlass(
      strong: true,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FdAvatar(name: chat.otherName, size: 52),
          const SizedBox(width: FdSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(chat.otherName, style: FdTypography.bodyStrong),
                Text(
                  '${chat.post.title} · ${_kindLabel(chat.post)}',
                  style: FdTypography.caption.copyWith(color: FdColors.primary),
                ),
                const SizedBox(height: FdSpacing.xxs),
                Text(
                  last == null
                      ? chat.summary
                      : '${last.mine ? 'Tú: ' : ''}${last.text}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: FdTypography.caption,
                ),
              ],
            ),
          ),
          const SizedBox(width: FdSpacing.xs),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(shortTime(chat.lastActivity), style: FdTypography.caption),
              const SizedBox(height: FdSpacing.sm),
              if (chat.unread)
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: FdColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
