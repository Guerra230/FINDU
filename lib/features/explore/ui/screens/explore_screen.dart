import 'package:flutter/material.dart';

import 'package:findu/core/demo/demo_data.dart';
import 'package:findu/core/demo/demo_visuals.dart';
import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_routes.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  PostKind? _kind;
  String? _category;
  PostIntent? _intent;
  String _query = '';

  List<String> get _categories {
    final values = <String>[];
    for (final post in DemoData.posts) {
      if ((_kind == null || post.kind == _kind) && !values.contains(post.category)) values.add(post.category);
    }
    return values;
  }

  @override
  Widget build(BuildContext context) {
    final query = _query.trim().toLowerCase();
    final posts = DemoData.posts.where((p) {
      if (_kind != null && p.kind != _kind) return false;
      if (_category != null && p.category != _category) return false;
      if (_intent != null && p.intent != _intent) return false;
      if (query.isNotEmpty && !'${p.title} ${p.place} ${p.category}'.toLowerCase().contains(query)) return false;
      return true;
    }).toList();

    return FdBackground(
      child: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: FdLargeTitle(
                title: 'Explorar',
                trailing: FdIconButton(
                  icon: Icons.map_outlined,
                  tooltip: 'Ver mapa',
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.map),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: FdSpacing.screen),
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
                options: const {null: 'Todo', PostKind.object: 'Objetos', PostKind.pet: 'Mascotas'},
                selected: _kind,
                onChanged: (v) => setState(() {
                  _kind = v;
                  _category = null;
                }),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: FdSpacing.xs)),
            SliverToBoxAdapter(
              child: FdChipBar<String?>(
                options: {null: 'Todas', for (final c in _categories) c: c},
                selected: _category,
                onChanged: (v) => setState(() => _category = v),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: FdSpacing.xs)),
            SliverToBoxAdapter(
              child: FdChipBar<PostIntent?>(
                options: const {null: 'Perdidos y encontrados', PostIntent.lost: 'Perdidos', PostIntent.found: 'Encontrados'},
                selected: _intent,
                onChanged: (v) => setState(() => _intent = v),
              ),
            ),
            if (posts.isEmpty)
              SliverToBoxAdapter(
                child: FdEmptyState(
                  title: 'No hay resultados',
                  message: 'Prueba con otro filtro o publica lo que perdiste.',
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
                padding: const EdgeInsets.fromLTRB(FdSpacing.screen, FdSpacing.md, FdSpacing.screen, 120),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                        onTap: () => Navigator.pushNamed(context, AppRoutes.postDetail, arguments: post.id),
                        onMap: () => Navigator.pushNamed(context, AppRoutes.map, arguments: post.id),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
