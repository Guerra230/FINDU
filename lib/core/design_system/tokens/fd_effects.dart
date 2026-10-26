import 'package:flutter/material.dart';

import 'package:findu/core/design_system/tokens/fd_colors.dart';

abstract final class FdEffects {
  static const double glassBlur = 24;

  static const softShadow = [
    BoxShadow(color: FdColors.shadow, blurRadius: 24, offset: Offset(0, 8)),
  ];

  static const buttonShadow = [
    BoxShadow(color: Color(0x403AAFFE), blurRadius: 24, spreadRadius: -6, offset: Offset(0, 10)),
  ];
}
