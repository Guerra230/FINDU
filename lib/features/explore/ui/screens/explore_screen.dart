import 'package:flutter/material.dart';

import 'package:findu/core/navigation/placeholder_screen.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabPlaceholder(figma: '09', title: 'Explorar');
  }
}
