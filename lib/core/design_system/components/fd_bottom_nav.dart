import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:findu/core/design_system/tokens/fd_colors.dart';
import 'package:findu/core/design_system/tokens/fd_effects.dart';
import 'package:findu/core/design_system/tokens/fd_gradients.dart';
import 'package:findu/core/design_system/tokens/fd_radius.dart';
import 'package:findu/core/design_system/tokens/fd_spacing.dart';

class FdNavItem {
  const FdNavItem({required this.icon, required this.activeIcon, required this.label});

  final IconData icon;
  final IconData activeIcon;
  final String label;
}

class FdBottomNav extends StatelessWidget {
  const FdBottomNav({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    required this.onCenterTap,
  });

  final List<FdNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onCenterTap;

  @override
  Widget build(BuildContext context) {
    final half = items.length ~/ 2;
    final children = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      if (i == half) children.add(_CenterButton(onTap: onCenterTap));
      children.add(_NavButton(item: items[i], selected: i == currentIndex, onTap: () => onTap(i)));
    }

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(FdSpacing.md, 0, FdSpacing.md, FdSpacing.md),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(FdRadius.pill),
          boxShadow: FdEffects.softShadow,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(FdRadius.pill),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: FdEffects.glassBlur, sigmaY: FdEffects.glassBlur),
            child: Container(
              height: 68,
              padding: const EdgeInsets.symmetric(horizontal: FdSpacing.xs),
              decoration: BoxDecoration(
                color: FdColors.glass,
                borderRadius: BorderRadius.circular(FdRadius.pill),
                border: Border.all(color: FdColors.glassBorder),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: children,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.item, required this.selected, required this.onTap});

  final FdNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: item.label,
      selected: selected,
      button: true,
      child: InkResponse(
        onTap: onTap,
        radius: 28,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: selected ? FdColors.primarySoft : Colors.transparent,
          ),
          child: Icon(
            selected ? item.activeIcon : item.icon,
            color: selected ? FdColors.primary : FdColors.textSecondary,
            size: 26,
          ),
        ),
      ),
    );
  }
}

class _CenterButton extends StatelessWidget {
  const _CenterButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Publicar',
      button: true,
      child: InkResponse(
        onTap: onTap,
        radius: 30,
        child: Container(
          width: 52,
          height: 52,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: FdGradients.button,
            boxShadow: FdEffects.buttonShadow,
          ),
          child: const Icon(Icons.add_rounded, color: FdColors.onPrimary, size: 30),
        ),
      ),
    );
  }
}
