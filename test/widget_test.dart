import 'package:flutter_test/flutter_test.dart';

import 'package:findu/core/demo/demo_data.dart';
import 'package:findu/core/navigation/app_router.dart';
import 'package:findu/core/navigation/screen_catalog.dart';

void main() {
  test('cada pantalla del catálogo tiene su ruta', () {
    for (final screen in screenCatalog) {
      expect(AppRouter.routes.containsKey(screen.route), isTrue, reason: screen.title);
    }
  });

  test('los objetos encontrados tienen 3 preguntas', () {
    for (final post in DemoData.posts.where((p) => p.intent == PostIntent.found)) {
      expect(post.questions.length, 3, reason: post.title);
    }
  });
}
