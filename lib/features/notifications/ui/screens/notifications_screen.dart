import 'package:flutter/material.dart';

import 'package:findu/core/demo/demo_data.dart';
import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_routes.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _read = <int>{};
  bool _onlyUnread = false;

  bool _isUnread(int index) => DemoData.notifications[index].unread && !_read.contains(index);

  IconData _iconFor(DemoNotification n) {
    final title = n.title.toLowerCase();
    if (title.contains('verificación')) return Icons.verified_outlined;
    if (title.contains('recompensa')) return Icons.payments_outlined;
    if (title.contains('avistamiento')) return Icons.visibility_outlined;
    return Icons.search_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final indexes = [
      for (var i = 0; i < DemoData.notifications.length; i++)
        if (!_onlyUnread || _isUnread(i)) i,
    ];

    return FdScaffold(
      body: Column(
        children: [
          FdScreenHeader(
            title: 'Notificaciones',
            trailing: FdIconButton(
              icon: Icons.tune_rounded,
              tooltip: 'Configurar alertas',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.alertSettings),
            ),
          ),
          FdChipBar<bool>(
            options: const {false: 'Todas', true: 'Sin leer'},
            selected: _onlyUnread,
            onChanged: (v) => setState(() => _onlyUnread = v),
          ),
          Expanded(
            child: indexes.isEmpty
                ? const Center(
                    child: FdEmptyState(
                      mood: FdMood.feliz,
                      title: 'Estás al día',
                      message: 'No tienes notificaciones sin leer.',
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(FdSpacing.screen, FdSpacing.md, FdSpacing.screen, FdSpacing.xl),
                    itemCount: indexes.length,
                    separatorBuilder: (_, _) => const SizedBox(height: FdSpacing.sm),
                    itemBuilder: (context, i) {
                      final index = indexes[i];
                      final n = DemoData.notifications[index];
                      final unread = _isUnread(index);
                      return FdListRow(
                        leading: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: FdColors.primarySoft,
                            borderRadius: BorderRadius.circular(FdRadius.sm),
                          ),
                          child: Icon(_iconFor(n), color: FdColors.primary),
                        ),
                        title: n.title,
                        subtitle: n.body,
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(n.time, style: FdTypography.caption),
                            const SizedBox(height: FdSpacing.xs),
                            if (unread)
                              Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(color: FdColors.primary, shape: BoxShape.circle),
                              ),
                          ],
                        ),
                        onTap: () {
                          setState(() => _read.add(index));
                          if (n.postId != null) {
                            Navigator.pushNamed(context, AppRoutes.postDetail, arguments: n.postId);
                          }
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
