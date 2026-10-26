import 'package:flutter/material.dart';

import 'package:findu/core/design_system/tokens/fd_colors.dart';

class FdBackground extends StatelessWidget {
  const FdBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: FdColors.background),
      child: Stack(
        children: [
          const Positioned(top: -90, right: -110, child: _Glow(size: 300, opacity: 0.14)),
          const Positioned(bottom: 120, left: -130, child: _Glow(size: 280, opacity: 0.08)),
          Positioned.fill(child: child),
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.size, required this.opacity});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              FdColors.primary.withValues(alpha: opacity),
              FdColors.primary.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }
}

class FdScaffold extends StatelessWidget {
  const FdScaffold({super.key, required this.body, this.bottomBar});

  final Widget body;
  final Widget? bottomBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FdColors.background,
      extendBody: true,
      body: FdBackground(child: SafeArea(bottom: bottomBar == null, child: body)),
      bottomNavigationBar: bottomBar,
    );
  }
}
