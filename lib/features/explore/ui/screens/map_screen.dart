import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/models/post.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/core/utils/formatters.dart';
import 'package:findu/features/explore/ui/widgets/fake_map.dart';
import 'package:findu/features/posts/ui/widgets/feed_scope.dart';
import 'package:findu/features/posts/ui/widgets/post_loader.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      FeedScope(child: _MapView(initialId: routeId(context)));
}

class _MapView extends StatefulWidget {
  const _MapView({this.initialId});

  final String? initialId;

  @override
  State<_MapView> createState() => _MapViewState();
}

class _MapViewState extends State<_MapView> {
  PostKind? _kind;
  late String? _selectedId = widget.initialId;

  List<MapPin> _pins(List<Post> posts) {
    if (posts.isEmpty) return [];
    final lats = posts.map((p) => p.latitude);
    final lngs = posts.map((p) => p.longitude);
    final minLat = lats.reduce(math.min);
    final maxLat = lats.reduce(math.max);
    final minLng = lngs.reduce(math.min);
    final maxLng = lngs.reduce(math.max);
    double scale(double value, double min, double max) =>
        max - min < 0.0001 ? 0 : ((value - min) / (max - min)) * 1.7 - 0.85;

    return [
      for (var i = 0; i < posts.length; i++)
        MapPin(
          id: posts[i].id,
          position: Alignment(
            scale(posts[i].longitude, minLng, maxLng) + (i % 3 - 1) * 0.04,
            -scale(posts[i].latitude, minLat, maxLat) + (i % 2) * 0.04,
          ),
          isPet: posts[i].isPet,
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return FdScaffold(
      body: Column(
        children: [
          const FdScreenHeader(title: 'Mapa'),
          FdChipBar<PostKind?>(
            options: const {
              null: 'Todo',
              PostKind.object: 'Objetos',
              PostKind.pet: 'Mascotas',
            },
            selected: _kind,
            onChanged: (v) => setState(() => _kind = v),
          ),
          Expanded(
            child: FeedBuilder(
              builder: (context, all) {
                final posts = all
                    .where((p) => _kind == null || p.kind == _kind)
                    .toList();
                final selected =
                    posts.where((p) => p.id == _selectedId).firstOrNull ??
                    posts.firstOrNull;
                return Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(FdSpacing.screen),
                        child: FakeMap(
                          pins: _pins(posts),
                          selectedId: selected?.id,
                          onPinTap: (id) => setState(() => _selectedId = id),
                        ),
                      ),
                    ),
                    if (selected != null)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          FdSpacing.screen,
                          0,
                          FdSpacing.screen,
                          FdSpacing.md,
                        ),
                        child: FdGlass(
                          strong: true,
                          radius: FdRadius.lg,
                          child: Row(
                            children: [
                              PostThumb(post: selected, size: 72),
                              const SizedBox(width: FdSpacing.sm),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      selected.title,
                                      style: FdTypography.h2,
                                    ),
                                    Text(
                                      '${selected.place} · ${selected.ago}',
                                      style: FdTypography.caption,
                                    ),
                                    const SizedBox(height: FdSpacing.xxs),
                                    FdBadge.status(
                                      selected.status,
                                      feminine: selected.feminine,
                                    ),
                                  ],
                                ),
                              ),
                              FdIconButton(
                                icon: Icons.arrow_forward_rounded,
                                filled: true,
                                tooltip: 'Ver publicación',
                                onPressed: () => Navigator.pushNamed(
                                  context,
                                  AppRoutes.postDetail,
                                  arguments: selected.id,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
