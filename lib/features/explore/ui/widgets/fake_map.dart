import 'package:flutter/material.dart';

import 'package:findu/core/design_system/design_system.dart';

class MapPin {
  const MapPin({required this.id, required this.position, required this.isPet});

  final String id;
  final Alignment position;
  final bool isPet;
}

class FakeMap extends StatelessWidget {
  const FakeMap({super.key, required this.pins, required this.selectedId, required this.onPinTap});

  final List<MapPin> pins;
  final String? selectedId;
  final ValueChanged<String> onPinTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(FdRadius.lg),
      child: DecoratedBox(
        decoration: const BoxDecoration(color: FdColors.primarySoft),
        child: Stack(
          children: [
            Positioned.fill(child: CustomPaint(painter: _StreetsPainter())),
            for (final pin in pins)
              Align(
                alignment: pin.position,
                child: _Pin(
                  selected: pin.id == selectedId,
                  isPet: pin.isPet,
                  onTap: () => onPinTap(pin.id),
                ),
              ),
            const Positioned(
              left: FdSpacing.sm,
              top: FdSpacing.sm,
              child: FdGlass(
                strong: true,
                radius: FdRadius.sm,
                padding: EdgeInsets.symmetric(horizontal: FdSpacing.sm, vertical: FdSpacing.xs),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Legend(color: FdColors.primary, label: 'Objetos'),
                    SizedBox(height: FdSpacing.xxs),
                    _Legend(color: FdColors.lost, label: 'Mascotas'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: FdSpacing.xs),
        Text(label, style: FdTypography.caption.copyWith(color: FdColors.textPrimary)),
      ],
    );
  }
}

class _Pin extends StatelessWidget {
  const _Pin({required this.selected, required this.isPet, required this.onTap});

  final bool selected;
  final bool isPet;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isPet ? FdColors.lost : FdColors.primary;
    final size = selected ? 56.0 : 44.0;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color.withValues(alpha: 0.2)),
        alignment: Alignment.center,
        child: Container(
          width: selected ? 22 : 16,
          height: selected ? 22 : 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: Border.all(color: FdColors.surface, width: 3),
          ),
        ),
      ),
    );
  }
}

class _StreetsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final park = Paint()..color = FdColors.success.withValues(alpha: 0.18);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(size.width * 0.06, size.height * 0.05, size.width * 0.36, size.height * 0.18), const Radius.circular(16)),
      park,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(size.width * 0.58, size.height * 0.62, size.width * 0.33, size.height * 0.22), const Radius.circular(16)),
      park,
    );
    final street = Paint()..color = FdColors.surface;
    canvas.drawRect(Rect.fromLTWH(0, size.height * 0.42, size.width, 16), street);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.45, 0, 16, size.height), street);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.78, 0, 12, size.height), street);
    final river = Paint()..color = FdColors.primary.withValues(alpha: 0.25);
    canvas.drawRect(Rect.fromLTWH(0, size.height * 0.9, size.width, 28), river);
  }

  @override
  bool shouldRepaint(_StreetsPainter oldDelegate) => false;
}
