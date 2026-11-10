import 'package:flutter_test/flutter_test.dart';

import 'package:findu/core/navigation/app_router.dart';
import 'package:findu/core/navigation/screen_catalog.dart';
import 'package:findu/core/utils/formatters.dart';

void main() {
  test('cada pantalla del catálogo tiene su ruta', () {
    for (final screen in screenCatalog) {
      expect(AppRouter.routes.containsKey(screen.route), isTrue, reason: screen.title);
    }
  });

  test('formatea pesos colombianos', () {
    expect(formatCop(500000), '\$500.000');
    expect(formatCop(5000), '\$5.000');
    expect(parseCop('\$1.200'), 1200);
    expect(parseCop(''), isNull);
  });
}
