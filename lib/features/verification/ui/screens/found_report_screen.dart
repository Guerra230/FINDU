import 'package:flutter/material.dart';

import 'package:findu/core/demo/demo_data.dart';
import 'package:findu/core/demo/demo_visuals.dart';
import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/features/verification/ui/widgets/verification_parts.dart';

class FoundReportScreen extends StatefulWidget {
  const FoundReportScreen({super.key});

  @override
  State<FoundReportScreen> createState() => _FoundReportScreenState();
}

class _FoundReportScreenState extends State<FoundReportScreen> {
  final _photos = <String>{};
  String? _where;
  String? _state;

  @override
  Widget build(BuildContext context) {
    final post = DemoData.post(routeId(context));
    final photoSlots = post.isPet ? const ['Cara', 'Cuerpo completo'] : const ['De frente', 'Detalle'];
    final whereOptions = post.isPet ? const ['Conmigo', 'Veterinaria', 'Otro'] : const ['Conmigo', 'Portería', 'Otro'];
    final stateOptions = post.isPet ? const ['Tranquila', 'Asustada', 'Herida'] : const ['Buen estado', 'Dañado'];
    final ready = _photos.length == photoSlots.length && _where != null && _state != null;

    return FdScaffold(
      body: Column(
        children: [
          FdScreenHeader(title: post.feminine ? 'La encontré' : 'Lo encontré'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(FdSpacing.screen, FdSpacing.xs, FdSpacing.screen, FdSpacing.lg),
              children: [
                PostSummaryRow(post: post, subtitle: '${post.title} de ${post.author}'),
                const SizedBox(height: FdSpacing.md),
                FdGlass(
                  strong: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text('Fotos', style: FdTypography.bodyStrong)),
                          Text('${_photos.length} de ${photoSlots.length} obligatorias', style: FdTypography.caption),
                        ],
                      ),
                      const SizedBox(height: FdSpacing.sm),
                      Row(
                        children: [
                          for (final slot in photoSlots) ...[
                            Expanded(
                              child: _PhotoSlot(
                                label: slot,
                                added: _photos.contains(slot),
                                onTap: () => setState(() {
                                  if (!_photos.remove(slot)) _photos.add(slot);
                                }),
                              ),
                            ),
                            if (slot != photoSlots.last) const SizedBox(width: FdSpacing.sm),
                          ],
                        ],
                      ),
                      const SizedBox(height: FdSpacing.sm),
                      FdSteps(current: _photos.length, total: photoSlots.length),
                    ],
                  ),
                ),
                const SizedBox(height: FdSpacing.md),
                Text('¿Dónde está ahora?', style: FdTypography.bodyStrong),
                const SizedBox(height: FdSpacing.xs),
                Wrap(
                  spacing: FdSpacing.xs,
                  runSpacing: FdSpacing.xs,
                  children: [
                    for (final o in whereOptions) FdChip(label: o, selected: _where == o, onTap: () => setState(() => _where = o)),
                  ],
                ),
                const SizedBox(height: FdSpacing.md),
                Text(post.isPet ? '¿Cómo está?' : 'Estado del objeto', style: FdTypography.bodyStrong),
                const SizedBox(height: FdSpacing.xs),
                Wrap(
                  spacing: FdSpacing.xs,
                  runSpacing: FdSpacing.xs,
                  children: [
                    for (final o in stateOptions) FdChip(label: o, selected: _state == o, onTap: () => setState(() => _state = o)),
                  ],
                ),
                const SizedBox(height: FdSpacing.md),
                FdInfoNote(
                  message: 'Al enviar se abre el chat con ${post.firstName}. Las fotos ayudan a confirmar que es ${post.feminine ? 'la' : 'el'} correct${post.feminine ? 'a' : 'o'}.',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(FdSpacing.screen, 0, FdSpacing.screen, FdSpacing.md),
            child: FdButton(
              label: 'Enviar y abrir chat',
              onPressed: ready
                  ? () => Navigator.pushReplacementNamed(context, AppRoutes.chat, arguments: post.id)
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoSlot extends StatelessWidget {
  const _PhotoSlot({required this.label, required this.added, required this.onTap});

  final String label;
  final bool added;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Material(
            color: added ? FdColors.primarySoft : FdColors.background,
            borderRadius: BorderRadius.circular(FdRadius.md),
            child: InkWell(
              borderRadius: BorderRadius.circular(FdRadius.md),
              onTap: onTap,
              child: Icon(
                added ? Icons.check_circle_rounded : Icons.photo_camera_outlined,
                color: FdColors.primary,
                size: 32,
              ),
            ),
          ),
        ),
        const SizedBox(height: FdSpacing.xxs),
        Text(label, style: FdTypography.caption),
      ],
    );
  }
}
