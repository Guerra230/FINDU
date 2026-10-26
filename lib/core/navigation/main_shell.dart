import 'package:flutter/material.dart';

import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/features/chat/ui/screens/chats_screen.dart';
import 'package:findu/features/explore/ui/screens/explore_screen.dart';
import 'package:findu/features/home/ui/screens/home_screen.dart';
import 'package:findu/features/profile/ui/screens/profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key, this.initialTab = AppTabs.home});

  final int initialTab;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _index = widget.initialTab.clamp(0, _tabs.length - 1).toInt();

  static const _tabs = <Widget>[
    HomeScreen(),
    ExploreScreen(),
    ChatsScreen(),
    ProfileScreen(),
  ];

  static const _items = <FdNavItem>[
    FdNavItem(icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: 'Inicio'),
    FdNavItem(icon: Icons.explore_outlined, activeIcon: Icons.explore, label: 'Explorar'),
    FdNavItem(icon: Icons.chat_bubble_outline_rounded, activeIcon: Icons.chat_bubble_rounded, label: 'Chats'),
    FdNavItem(icon: Icons.account_circle_outlined, activeIcon: Icons.account_circle, label: 'Perfil'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FdColors.background,
      extendBody: true,
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: FdBottomNav(
        items: _items,
        currentIndex: _index,
        onTap: (index) => setState(() => _index = index),
        onCenterTap: () => Navigator.pushNamed(context, AppRoutes.publishObject),
      ),
    );
  }
}
