import 'package:flutter/material.dart';

import 'package:findu/core/demo/demo_data.dart';
import 'package:findu/core/design_system/design_system.dart';

extension DemoPostVisuals on DemoPost {
  IconData get icon => switch (category) {
        'Gato' || 'Perro' => Icons.pets_rounded,
        'Mochila' => Icons.backpack_outlined,
        'Billetera' => Icons.account_balance_wallet_outlined,
        'Termo' => Icons.local_drink_outlined,
        'Cartuchera' => Icons.edit_outlined,
        'Celular' => Icons.phone_android_rounded,
        'Parlante' => Icons.speaker_outlined,
        _ => Icons.inventory_2_outlined,
      };

  FdStatus get status => intent == PostIntent.lost ? FdStatus.lost : FdStatus.found;

  bool get feminine =>
      const {'Luna', 'Alaska', 'Martina', 'Canelita', 'Titi'}.contains(title) ||
      const {'Mochila', 'Billetera', 'Cartuchera'}.contains(category);

  bool get isPet => kind == PostKind.pet;

  bool get isMine => author == DemoData.me.name;

  String get firstName => author.split(' ').first;

  String get placeAgo => '$place, $ago';
}

String formatCop(int value) {
  final digits = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  return '\$$buffer';
}

String? routeId(BuildContext context) {
  final args = ModalRoute.of(context)?.settings.arguments;
  return args is String ? args : null;
}
