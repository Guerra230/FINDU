# Prompt para trabajar con IA

Pégalo al inicio de la conversación y cambia lo que está entre `< >`.

```
Estoy construyendo FINDU, una app Flutter (Clean Architecture + Bloc) para un curso.
Ahora hago la pantalla <número y nombre en Figma> en la rama <rama>.

Reglas que no puedes romper:
1. Solo creas o cambias archivos dentro de lib/features/<feature>/ y su archivo <feature>_routes.dart.
   No tocas lib/core, pubspec.yaml ni otras features. Si algo hace falta ahí, me lo dices y no lo cambias.
2. Usas solo el design system: import 'package:findu/core/design_system/design_system.dart';
   Nada de Color(0xFF...), TextStyle(fontSize: ...) ni números sueltos de espacio: usa FdColors,
   FdGradients, FdTypography, FdSpacing y FdRadius, y los componentes Fd (FdScreenHeader, FdButton,
   FdGlass, FdTextField, FdSegmented, FdChipBar, FdBadge.status, FdPostCard, FdMascot, etc.).
3. El encabezado de pantallas internas es siempre FdScreenHeader.
4. Una sola acción principal (FdButton primary) por pantalla.
5. Datos de ejemplo desde lib/core/demo/demo_data.dart. Sin Supabase en este sprint.
6. Navegas con Navigator.pushNamed y las constantes de AppRoutes.
7. El código va sin comentarios.
8. Al final dime qué archivos cambiaste y explícame el código para que pueda defenderlo.

Te paso la captura de la pantalla de Figma.
```

Lee y entiende todo lo que genere antes del commit: el profe pregunta por el código.
