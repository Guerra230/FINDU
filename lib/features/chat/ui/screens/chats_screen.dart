import 'package:flutter/material.dart';

import 'package:findu/core/demo/demo_data.dart';
import 'package:findu/core/demo/demo_visuals.dart';
import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/core/navigation/main_shell.dart';

enum _ChatFilter { all, unread, objects, pets }

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  _ChatFilter _filter = _ChatFilter.all;
  String _query = '';
  final _read = <String>{};

  @override
  Widget build(BuildContext context) {
    final query = _query.trim().toLowerCase();
    final chats = DemoData.chats.where((c) {
      final post = DemoData.post(c.postId);
      final unread = c.unread && !_read.contains(c.postId);
      final matches = query.isEmpty || '${c.person} ${post.title}'.toLowerCase().contains(query);
      final passesFilter = switch (_filter) {
        _ChatFilter.all => true,
        _ChatFilter.unread => unread,
        _ChatFilter.objects => !post.isPet,
        _ChatFilter.pets => post.isPet,
      };
      return matches && passesFilter;
    }).toList();

    return FdBackground(
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 120),
          children: [
            const FdLargeTitle(title: 'Chats'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: FdSpacing.screen),
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
            if (chats.isEmpty)
              FdEmptyState(
                mood: FdMood.esperando,
                title: 'Aún no tienes chats',
                message: 'Un chat se abre cuando verificas que algo es tuyo o cuando reportas que encontraste algo.',
                actionLabel: 'Explorar',
                onAction: () => MainShell.goTo(context, AppTabs.explore),
              )
            else
              for (final chat in chats)
                Padding(
                  padding: const EdgeInsets.fromLTRB(FdSpacing.screen, 0, FdSpacing.screen, FdSpacing.sm),
                  child: _ChatRow(
                    chat: chat,
                    unread: chat.unread && !_read.contains(chat.postId),
                    onTap: () {
                      setState(() => _read.add(chat.postId));
                      Navigator.pushNamed(context, AppRoutes.chat, arguments: chat.postId);
                    },
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

String _kindLabel(DemoPost post) {
  final lost = post.intent == PostIntent.lost;
  if (post.isPet) return lost ? 'mascota perdida' : 'mascota encontrada';
  return lost ? 'objeto perdido' : 'objeto encontrado';
}

class _ChatRow extends StatelessWidget {
  const _ChatRow({required this.chat, required this.unread, required this.onTap});

  final DemoChat chat;
  final bool unread;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final post = DemoData.post(chat.postId);
    return FdGlass(
      strong: true,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FdAvatar(name: chat.person, size: 52),
          const SizedBox(width: FdSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(chat.person, style: FdTypography.bodyStrong),
                Text(
                  '${post.title} · ${_kindLabel(post)}',
                  style: FdTypography.caption.copyWith(color: FdColors.primary),
                ),
                const SizedBox(height: FdSpacing.xxs),
                Text(chat.lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis, style: FdTypography.caption),
              ],
            ),
          ),
          const SizedBox(width: FdSpacing.xs),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(chat.time, style: FdTypography.caption),
              const SizedBox(height: FdSpacing.sm),
              if (unread)
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(color: FdColors.primary, shape: BoxShape.circle),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
