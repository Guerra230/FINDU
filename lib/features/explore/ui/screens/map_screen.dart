import 'package:flutter/material.dart';

import 'package:findu/core/demo/demo_data.dart';
import 'package:findu/core/demo/demo_visuals.dart';
import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/features/explore/ui/widgets/fake_map.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  PostKind? _kind;
  String? _selectedId;
  bool _initialized = false;

  static const _positions = <Alignment>[
    Alignment(0.25, 0.05),
    Alignment(-0.55, -0.35),
    Alignment(0.6, -0.6),
    Alignment(-0.2, 0.45),
    Alignment(0.75, 0.3),
    Alignment(-0.7, 0.2),
    Alignment(0.1, -0.75),
    Alignment(-0.4, 0.75),
    Alignment(0.45, 0.7),
    Alignment(-0.8, -0.7),
    Alignment(0.85, -0.15),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    _selectedId = routeId(context) ?? DemoData.posts.first.id;
  }

  @override
  Widget build(BuildContext context) {
    final posts = DemoData.posts.where((p) => _kind == null || p.kind == _kind).toList();
    final selected = posts.where((p) => p.id == _selectedId).firstOrNull ?? (posts.isEmpty ? null : posts.first);

    return FdScaffold(
      body: Column(
        children: [
          const FdScreenHeader(title: 'Mapa'),
          FdChipBar<PostKind?>(
            options: const {null: 'Último avistamiento', PostKind.object: 'Objetos', PostKind.pet: 'Mascotas'},
            selected: _kind,
            onChanged: (v) => setState(() => _kind = v),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(FdSpacing.screen),
              child: FakeMap(
                pins: [
                  for (var i = 0; i < posts.length; i++)
                    MapPin(
                      id: posts[i].id,
                      position: _positions[DemoData.posts.indexOf(posts[i]) % _positions.length],
                      isPet: posts[i].isPet,
                    ),
                ],
                selectedId: selected?.id,
                onPinTap: (id) => setState(() => _selectedId = id),
              ),
            ),
          ),
          if (selected != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(FdSpacing.screen, 0, FdSpacing.screen, FdSpacing.md),
              child: FdGlass(
                strong: true,
                radius: FdRadius.lg,
                child: Row(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: FdColors.primarySoft,
                        borderRadius: BorderRadius.circular(FdRadius.md),
                      ),
                      child: Icon(selected.icon, color: FdColors.primary, size: 36),
                    ),
                    const SizedBox(width: FdSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(selected.title, style: FdTypography.h2),
                          Text('${selected.place} · ${selected.ago}', style: FdTypography.caption),
                          const SizedBox(height: FdSpacing.xxs),
                          FdBadge.status(selected.status, feminine: selected.feminine),
                        ],
                      ),
                    ),
                    FdIconButton(
                      icon: Icons.arrow_forward_rounded,
                      filled: true,
                      tooltip: 'Ver publicación',
                      onPressed: () => Navigator.pushNamed(context, AppRoutes.postDetail, arguments: selected.id),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
