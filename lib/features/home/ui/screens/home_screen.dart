import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/models/post.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/core/navigation/main_shell.dart';
import 'package:findu/features/notifications/ui/bloc/notifications_cubit.dart';
import 'package:findu/features/posts/ui/bloc/feed_bloc.dart';
import 'package:findu/features/posts/ui/widgets/feed_scope.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeedScope(child: NotificationsScope(child: _HomeView()));
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  PostKind? _kind;

  Future<void> _refresh() async {
    context.read<FeedBloc>().add(const FeedRequested());
    await context.read<NotificationsCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return FdBackground(
      child: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            padding: const EdgeInsets.only(bottom: 120),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  FdSpacing.screen,
                  FdSpacing.md,
                  FdSpacing.screen,
                  0,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: FdColors.primary,
                    ),
                    const SizedBox(width: FdSpacing.xxs),
                    Expanded(
                      child: Text(
                        'Cali, Valle del Cauca',
                        style: FdTypography.bodyStrong,
                      ),
                    ),
                    BlocBuilder<NotificationsCubit, NotificationsState>(
                      builder: (context, state) => FdIconButton(
                        icon: Icons.notifications_none_rounded,
                        tooltip: 'Notificaciones',
                        badgeCount: state.unread,
                        onPressed: () async {
                          await Navigator.pushNamed(
                            context,
                            AppRoutes.notifications,
                          );
                          if (context.mounted) {
                            context.read<NotificationsCubit>().load();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const FdLargeTitle(
                title: '¿Perdiste algo?',
                subtitle: 'Encuéntralo',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: FdSpacing.screen,
                ),
                child: FdGlass(
                  strong: true,
                  radius: FdRadius.pill,
                  onTap: () => MainShell.goTo(context, AppTabs.explore),
                  padding: const EdgeInsets.fromLTRB(
                    FdSpacing.md,
                    FdSpacing.xs,
                    FdSpacing.xs,
                    FdSpacing.xs,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.search_rounded,
                        color: FdColors.textSecondary,
                      ),
                      const SizedBox(width: FdSpacing.xs),
                      Expanded(
                        child: Text(
                          'Busca objetos o mascotas…',
                          style: FdTypography.body.copyWith(
                            color: FdColors.textDisabled,
                          ),
                        ),
                      ),
                      FdIconButton(
                        icon: Icons.tune_rounded,
                        filled: true,
                        tooltip: 'Filtros',
                        onPressed: () =>
                            MainShell.goTo(context, AppTabs.explore),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: FdSpacing.md),
              FdChipBar<PostKind?>(
                options: const {
                  null: 'Todo',
                  PostKind.object: 'Objetos',
                  PostKind.pet: 'Mascotas',
                },
                selected: _kind,
                onChanged: (v) => setState(() => _kind = v),
              ),
              FdSectionHeader(
                title: 'Recientes',
                actionLabel: 'ver todo',
                onAction: () => MainShell.goTo(context, AppTabs.explore),
              ),
              FeedBuilder(
                builder: (context, posts) {
                  final recent = posts
                      .where((p) => _kind == null || p.kind == _kind)
                      .take(8)
                      .toList();
                  if (recent.isEmpty) {
                    return FdEmptyState(
                      title: 'Aún no hay publicaciones',
                      message:
                          'Sé el primero en publicar algo perdido o encontrado.',
                      actionLabel: 'Publicar',
                      onAction: () =>
                          Navigator.pushNamed(context, AppRoutes.publishObject),
                    );
                  }
                  return SizedBox(
                    height: 330,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: FdSpacing.screen,
                      ),
                      itemCount: recent.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(width: FdSpacing.md),
                      itemBuilder: (context, index) {
                        final post = recent[index];
                        return FdPostCard(
                          title: post.title,
                          subtitle: post.placeAgo,
                          status: post.status,
                          feminine: post.feminine,
                          icon: post.icon,
                          image: post.image,
                          width: 250,
                          height: 320,
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.postDetail,
                            arguments: post.id,
                          ),
                          onMap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.map,
                            arguments: post.id,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
