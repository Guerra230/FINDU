import 'package:flutter/material.dart';

import 'package:findu/core/navigation/placeholder_screen.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabPlaceholder(figma: '25', title: 'Chats');
  }
}
