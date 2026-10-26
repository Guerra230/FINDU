import 'package:flutter/material.dart';

import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/core/navigation/team.dart';

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({
    super.key,
    required this.figma,
    required this.title,
    this.showBack = true,
  });

  final String figma;
  final String title;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return FdScaffold(
      body: Column(
        children: [
          FdScreenHeader(title: title, showBack: showBack),
          Expanded(child: Center(child: PlaceholderBody(figma: figma))),
        ],
      ),
    );
  }
}

class TabPlaceholder extends StatelessWidget {
  const TabPlaceholder({super.key, required this.figma, required this.title});

  final String figma;
  final String title;

  @override
  Widget build(BuildContext context) {
    return FdBackground(
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FdLargeTitle(title: title),
            Expanded(child: Center(child: PlaceholderBody(figma: figma))),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

class PlaceholderBody extends StatelessWidget {
  const PlaceholderBody({super.key, required this.figma});

  final String figma;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FdEmptyState(
        mood: FdMood.buscando,
        title: 'Pantalla $figma en construcción',
        message: 'La construye ${Team.owner}. Mírala en Figma y ármala con los componentes del design system.',
        actionLabel: 'Ver todas las pantallas',
        onAction: () => Navigator.pushNamed(context, AppRoutes.devMenu),
      ),
    );
  }
}
