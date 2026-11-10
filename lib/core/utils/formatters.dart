import 'package:flutter/widgets.dart';

String formatCop(int value) {
  final digits = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  return '\$$buffer';
}

String timeAgo(DateTime date, {DateTime? now}) {
  final diff = (now ?? DateTime.now()).difference(date);
  if (diff.inMinutes < 1) return 'hace un momento';
  if (diff.inMinutes < 60) return 'hace ${diff.inMinutes} min';
  if (diff.inHours < 24) return 'hace ${diff.inHours} h';
  if (diff.inDays == 1) return 'ayer';
  if (diff.inDays < 7) return 'hace ${diff.inDays} días';
  return '${date.day}/${date.month}/${date.year}';
}

String shortTime(DateTime date, {DateTime? now}) {
  final today = now ?? DateTime.now();
  final local = date.toLocal();
  if (local.year == today.year &&
      local.month == today.month &&
      local.day == today.day) {
    final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final minute = local.minute.toString().padLeft(2, '0');
    return '$hour:$minute ${local.hour < 12 ? 'a. m.' : 'p. m.'}';
  }
  return timeAgo(date, now: now);
}

int? parseCop(String text) {
  final digits = text.replaceAll(RegExp(r'\D'), '');
  if (digits.isEmpty) return null;
  final value = int.parse(digits);
  return value == 0 ? null : value;
}

String? routeId(BuildContext context) {
  final args = ModalRoute.of(context)?.settings.arguments;
  return args is String ? args : null;
}
