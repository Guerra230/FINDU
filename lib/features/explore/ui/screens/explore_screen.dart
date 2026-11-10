import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/models/post.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/features/posts/ui/bloc/feed_bloc.dart';
import 'package:findu/features/posts/ui/widgets/feed_scope.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) => const FeedScope(child: _ExploreView());
}

class _ExploreView extends StatefulWidget {
  const _ExploreView();

  @override
  State<_ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<_ExploreView> {
  PostKind? _kind;
  String? _category;
  PostIntent? _intent;
  String _query = '';

  List<Post> _filter(List<Post> posts) {
    final query = _query.trim().toLowerCase();
    return posts.where((p) {
      if (_kind != null && p.kind != _kind) return false;
      if (_category != null && p.category != _category) return false;
      if (_intent != null && p.intent != _intent) return false;
      if (query.isNotEmpty &&
          !'${p.title} ${p.place} ${p.category}'.toLowerCase().contains(query)) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FeedBloc>().state;
    final categories = <String>[];
    for (final post in state.posts) {
      if ((_kind == null || post.kind == _kind) &&
          !categories.contains(post.category)) {
        categories.add(post.category);
      }
    }
    final posts = _filter(state.posts);

    return FdBackground(
      child: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () async =>
              context.read<FeedBloc>().add(const FeedRequested()),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: FdLargeTitle(
                  title: 'Explorar',
                  trailing: FdIconButton(
                    icon: Icons.map_outlined,
                    tooltip: 'Ver mapa',
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.map),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: FdSpacing.screen,
                  ),
                  child: FdTextField(
                    label: 'Buscar',
                    hint: 'Nombre, lugar o categoría',
                    onChanged: (v) => setState(() => _query = v),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: FdSpacing.md)),
              SliverToBoxAdapter(
                child: FdChipBar<PostKind?>(
                  options: const {
                    null: 'Todo',
                    PostKind.object: 'Objetos',
                    PostKind.pet: 'Mascotas',
                  },
                  selected: _kind,
                  onChanged: (v) => setState(() {
                    _kind = v;
                    _category = null;
                  }),
                ),
              ),
              if (categories.isNotEmpty) ...[
                const SliverToBoxAdapter(child: SizedBox(height: FdSpacing.xs)),
                SliverToBoxAdapter(
                  child: FdChipBar<String?>(
                    options: {null: 'Todas', for (final c in categories) c: c},
                    selected: _category,
                    onChanged: (v) => setState(() => _category = v),
                  ),
                ),
              ],
              const SliverToBoxAdapter(child: SizedBox(height: FdSpacing.xs)),
              SliverToBoxAdapter(
                child: FdChipBar<PostIntent?>(
                  options: const {
                    null: 'Perdidos y encontrados',
                    PostIntent.lost: 'Perdidos',
                    PostIntent.found: 'Encontrados',
                  },
                  selected: _intent,
                  onChanged: (v) => setState(() => _intent = v),
                ),
              ),
              if (state.status == FeedStatus.loading)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(FdSpacing.xl),
                    child: FdLoadingState(),
                  ),
                )
              else if (state.status == FeedStatus.failure &&
                  state.posts.isEmpty)
                SliverToBoxAdapter(
                  child: FdErrorState(
                    message: 'No pudimos cargar las publicaciones.',
                    onRetry: () =>
                        context.read<FeedBloc>().add(const FeedRequested()),
                  ),
                )
              else if (posts.isEmpty)
                SliverToBoxAdapter(
                  child: FdEmptyState(
                    title: 'No hay resultados',
                    message:
                        'Prueba con otro filtro o publica lo que perdiste.',
                    actionLabel: 'Quitar filtros',
                    onAction: () => setState(() {
                      _kind = null;
                      _category = null;
                      _intent = null;
                    }),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    FdSpacing.screen,
                    FdSpacing.md,
                    FdSpacing.screen,
                    120,
                  ),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: FdSpacing.sm,
                          crossAxisSpacing: FdSpacing.sm,
                          childAspectRatio: 0.72,
                        ),
                    delegate: SliverChildBuilderDelegate(
                      childCount: posts.length,
                      (context, index) {
                        final post = posts[index];
                        return FdPostCard(
                          title: post.title,
                          subtitle: post.placeAgo,
                          status: post.status,
                          feminine: post.feminine,
                          icon: post.icon,
                          image: post.image,
                          width: double.infinity,
                          height: double.infinity,
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
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
