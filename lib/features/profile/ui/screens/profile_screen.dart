import 'package:flutter/material.dart';

import 'package:findu/core/navigation/placeholder_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabPlaceholder(figma: '36', title: 'Mi perfil');
  }
}
