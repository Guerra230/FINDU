import 'package:flutter/material.dart';

import 'package:findu/core/design_system/components/fd_badge.dart';
import 'package:findu/core/design_system/tokens/fd_colors.dart';
import 'package:findu/core/design_system/tokens/fd_effects.dart';
import 'package:findu/core/design_system/tokens/fd_radius.dart';
import 'package:findu/core/design_system/tokens/fd_spacing.dart';
import 'package:findu/core/design_system/tokens/fd_typography.dart';

class FdPostCard extends StatelessWidget {
  const FdPostCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.icon,
    this.image,
    this.feminine = false,
    this.onTap,
    this.onMap,
    this.width = 180,
    this.height = 300,
  });

  final String title;
  final String subtitle;
  final FdStatus status;
  final IconData icon;
  final ImageProvider? image;
  final bool feminine;
  final VoidCallback? onTap;
  final VoidCallback? onMap;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(FdRadius.lg);
    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(borderRadius: radius, boxShadow: FdEffects.softShadow),
        child: ClipRRect(
          borderRadius: radius,
          child: Material(
            color: FdColors.primarySoft,
            child: InkWell(
              onTap: onTap,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (image != null)
                    Image(image: image!, fit: BoxFit.cover)
                  else
                    Center(child: Icon(icon, size: 64, color: FdColors.primary.withValues(alpha: 0.5))),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.5, 1],
                        colors: [Colors.transparent, Color(0x99000000)],
                      ),
                    ),
                  ),
                  Positioned(top: FdSpacing.sm, left: FdSpacing.sm, child: FdBadge.status(status, feminine: feminine)),
                  if (onMap != null)
                    Positioned(
                      top: FdSpacing.xs,
                      right: FdSpacing.xs,
                      child: IconButton(
                        tooltip: 'Ver en el mapa',
                        onPressed: onMap,
                        icon: const Icon(Icons.map_outlined, color: Colors.white),
                      ),
                    ),
                  Positioned(
                    left: FdSpacing.sm,
                    right: FdSpacing.sm,
                    bottom: FdSpacing.md,
                    child: Column(
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: FdTypography.h1.copyWith(color: Colors.white),
                        ),
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: FdTypography.caption.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
