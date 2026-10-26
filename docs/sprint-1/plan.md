# Sprint 1 · Interfaz completa (entrega: 27 de octubre)

**Objetivo:** todas las pantallas del prototipo construidas en Flutter, navegables y con datos de ejemplo. Sin Supabase ni lógica real: eso es el Sprint 2.

Figma: https://www.figma.com/design/FAhwhJ4rkuyxYau3C3WYDR, página **App corregida**. Cada pantalla tiene su número al inicio del nombre (por ejemplo `13 · Publicar objeto - Lo perdí`). Las copias para cada objeto o mascota (Termo, Alaska…) llevan el mismo número porque son la misma pantalla con otros datos.

## Lo que ya está en `main`

- Proyecto Flutter con estructura por features (Clean Architecture: en este sprint solo la capa `ui`).
- **Design system** Liquid Glass en `lib/core/design_system/`: tokens, tema, componentes, Findi y una galería. Guía: [docs/design-system.md](../design-system.md).
- Navegación: todas las rutas, la barra inferior (Inicio, Explorar, +, Chats, Perfil) y una pantalla temporal en cada ruta.
- Menú de desarrollo (`/dev`) para abrir cualquier pantalla directo.
- Datos de ejemplo en `lib/core/demo/demo_data.dart`.

## Pantallas por rama

| Rama | Pantallas (número en Figma) | Carpetas |
| --- | --- | --- |
| `feature/acceso` | 01 Login, 02 Registro universitario, 03 Elige tu universidad, 04 Registro ciudadano, 05 Recuperar contraseña, 06 Código, 07 Nueva contraseña | `features/auth/` |
| `feature/inicio-explorar` | 08 Inicio, 09 Explorar (con filtros), 10 Mapa, 11 Notificaciones, 12 Configurar alertas | `features/home/`, `features/explore/`, `features/notifications/` |
| `feature/publicar` | 13 Publicar objeto, 14 Reportar mascota, 15 Publicación lista, 16 Compartir reporte, 17 Impulsar, 18 Impulso activo, 19 Detalle de publicación | `features/publish/`, `features/posts/` |
| `feature/verificacion-chat` | 20 Verificación, 21 Pregunta 1 a 3, 22 Aprobada, 23 Fallida, 24 Encontré a…, 25 Chats, 26 Chat + S1 Confirmar entrega, 27 Hubo un problema, 28 Reporte enviado, 29 Entrega verificada | `features/verification/`, `features/chat/` |
| `feature/comunidades-perfil` | 30 Mis comunidades, 31 Unirse, 32 Solicitud pendiente, 33 Crear comunidad, 34 Solicitud enviada, 35 Panel de administración, 36 Perfil, 37 Métodos de pago | `features/communities/`, `features/profile/` |

## Reglas del flujo que la interfaz debe mostrar

- Login único con correo institucional **o** celular; registro universitario (cualquier universidad) o ciudadano.
- A una comunidad se entra con **código de acceso** o con **aprobación del admin**. Siempre hay admin.
- Lo encontrado se protege con **3 preguntas privadas**; hay máximo 2 intentos.
- El **punto de encuentro** lo acuerdan en el chat; la app no lo pone.
- La entrega se cierra cuando **los dos confirman**. "Hubo un problema" deja la publicación activa y la recompensa retenida.

## Cómo construir una pantalla

1. Mírala en Figma (toma captura).
2. Crea `lib/features/<feature>/ui/screens/<nombre>_screen.dart`. Lo que se repite va en `ui/widgets/`.
3. Usa **solo** componentes y tokens del design system.
4. En el `*_routes.dart` de la feature, cambia el `PlaceholderScreen` por la pantalla.
5. Conecta los botones a `AppRoutes`. Para un detalle, pasa el id: `Navigator.pushNamed(context, AppRoutes.postDetail, arguments: 'luna')`.
6. `flutter analyze` sin errores y prueba en el emulador.
7. Commit y push. Un commit por pantalla.

## Orden de trabajo

| Cuándo | Qué |
| --- | --- |
| Hoy | Subir la base a `main`. Rama `feature/acceso` y primer commit |
| Antes de la entrega | Una rama por fila de la tabla, cada una con su PR unido a `main` |
| Antes de clase | Repaso de todo el código y del flujo |

## Para la sustentación

Debo poder explicar:

- Cómo está organizado el proyecto (features, `core/`, design system).
- Cómo funciona la navegación: `AppRoutes`, los `*_routes.dart` y `MainShell` con la barra inferior y el botón +.
- Qué es un token y por qué no se escriben colores a mano.
- Cómo se hace el vidrio (`BackdropFilter` en `FdGlass`) y cómo se dibuja Findi (`CustomPainter`).
- Qué cambia en el Sprint 2: los datos de ejemplo se reemplazan por Supabase con Bloc, siguiendo el modelo de datos de la página Flujo.
