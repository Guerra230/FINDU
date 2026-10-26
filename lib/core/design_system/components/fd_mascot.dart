import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:findu/core/design_system/tokens/fd_colors.dart';
import 'package:findu/core/design_system/tokens/fd_gradients.dart';

enum FdMood { feliz, buscando, esperando, sorprendido, triste }

class FdMascot extends StatelessWidget {
  const FdMascot({super.key, this.mood = FdMood.feliz, this.size = 120});

  final FdMood mood;
  final double size;

  static const double _w = 160;
  static const double _h = 150;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Findi, ${mood.name}',
      image: true,
      child: SizedBox(
        width: size,
        height: size * _h / _w,
        child: CustomPaint(painter: _FindiPainter(mood)),
      ),
    );
  }
}

class _FindiPainter extends CustomPainter {
  _FindiPainter(this.mood);

  final FdMood mood;

  static const double eyeW = 36;
  static const double eyeH = 42;
  static const double leftX = 44;
  static const double rightX = 79;
  static const double eyeY = 54;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / FdMascot._w, size.height / FdMascot._h);
    _paintBody(canvas);
    _paintEyes(canvas);
    canvas.restore();
  }

  Path _bodyPath() {
    var path = Path()..addOval(const Rect.fromLTWH(0, 40, 160, 110));
    for (final rect in const [
      Rect.fromLTWH(12, 14, 72, 72),
      Rect.fromLTWH(48, 0, 86, 86),
      Rect.fromLTWH(96, 22, 62, 62),
    ]) {
      path = Path.combine(PathOperation.union, path, Path()..addOval(rect));
    }
    return path;
  }

  void _paintBody(Canvas canvas) {
    final body = _bodyPath();
    canvas.drawPath(
      body.shift(const Offset(0, 12)),
      Paint()
        ..color = FdColors.primary.withValues(alpha: 0.22)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14),
    );
    canvas.drawPath(
      body,
      Paint()..shader = FdGradients.mascot.createShader(const Rect.fromLTWH(0, 0, 160, 150)),
    );
    canvas.save();
    canvas.clipPath(body);
    canvas.drawPath(
      body.shift(const Offset(-6, -8)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 16
        ..color = Colors.white.withValues(alpha: 0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    canvas.restore();
    canvas.drawPath(
      body,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = Colors.white.withValues(alpha: 0.7),
    );
    canvas.save();
    canvas.translate(79, 23);
    canvas.rotate(-12 * math.pi / 180);
    canvas.drawOval(
      const Rect.fromLTWH(-23, -9, 46, 18),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.7)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    canvas.restore();
  }

  void _paintEyes(Canvas canvas) {
    switch (mood) {
      case FdMood.feliz:
        _happyArc(canvas, leftX);
        _happyArc(canvas, rightX + 6);
      case FdMood.sorprendido:
        _surprised(canvas);
      case FdMood.buscando:
        _openEyes(canvas, const Offset(8, 1), const Offset(8, 1), 17);
      case FdMood.esperando:
        _openEyes(canvas, const Offset(3, 7), const Offset(3, 7), 16);
        _lid(canvas, _eyeRect(leftX), 0.45, 0.45);
        _lid(canvas, _eyeRect(rightX), 0.45, 0.45);
      case FdMood.triste:
        _openEyes(canvas, const Offset(2, 8), const Offset(-2, 8), 17);
        _lid(canvas, _eyeRect(leftX), 0.55, 0.28);
        _lid(canvas, _eyeRect(rightX), 0.28, 0.55);
    }
  }

  void _openEyes(Canvas canvas, Offset leftPupil, Offset rightPupil, double pupil) {
    final left = _eyeRect(leftX);
    final right = _eyeRect(rightX);
    _eye(canvas, left);
    _eye(canvas, right);
    _pupil(canvas, left.center + leftPupil, pupil);
    _pupil(canvas, right.center + rightPupil, pupil);
  }

  void _surprised(Canvas canvas) {
    const left = Rect.fromLTWH(leftX - 3, eyeY - 6, eyeW + 4, eyeH + 6);
    const right = Rect.fromLTWH(rightX - 1, eyeY - 6, eyeW + 4, eyeH + 6);
    _eye(canvas, left);
    _eye(canvas, right);
    _pupil(canvas, left.center + const Offset(2, 2), 11);
    _pupil(canvas, right.center + const Offset(-2, 2), 11);
  }

  Rect _eyeRect(double x) => Rect.fromLTWH(x, eyeY, eyeW, eyeH);

  void _eye(Canvas canvas, Rect rect) {
    canvas.drawOval(rect.shift(const Offset(0, 2)), Paint()..color = FdColors.primaryDark.withValues(alpha: 0.15));
    canvas.drawOval(rect, Paint()..color = Colors.white);
    canvas.drawOval(
      rect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = FdColors.primary.withValues(alpha: 0.35),
    );
  }

  void _pupil(Canvas canvas, Offset center, double d) {
    canvas.drawCircle(center, d / 2, Paint()..color = FdColors.mascotInk);
    final s = math.max(4.0, d * 0.3);
    canvas.drawCircle(
      Offset(center.dx - d / 2 + d * 0.18 + s / 2, center.dy - d / 2 + d * 0.15 + s / 2),
      s / 2,
      Paint()..color = Colors.white,
    );
  }

  void _lid(Canvas canvas, Rect eye, double leftCover, double rightCover) {
    final lid = Path()
      ..moveTo(eye.left, eye.top)
      ..lineTo(eye.right, eye.top)
      ..lineTo(eye.right, eye.top + eye.height * rightCover)
      ..lineTo(eye.left, eye.top + eye.height * leftCover)
      ..close();
    canvas.save();
    canvas.clipPath(Path()..addOval(eye));
    canvas.drawPath(lid, Paint()..color = FdColors.mascotLid);
    canvas.restore();
  }

  void _happyArc(Canvas canvas, double x) {
    final arc = Path()
      ..moveTo(x, eyeY + 26)
      ..quadraticBezierTo(x + 15, eyeY + 6, x + 30, eyeY + 26);
    canvas.drawPath(
      arc,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round
        ..color = FdColors.mascotInk,
    );
  }

  @override
  bool shouldRepaint(_FindiPainter oldDelegate) => oldDelegate.mood != mood;
}
