import 'package:flutter/material.dart';

import 'package:findu/core/navigation/placeholder_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabPlaceholder(figma: '08', title: '¿Perdiste algo?');
  }
}
