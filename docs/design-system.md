# Design system de FINDU

Todo lo visual sale de `lib/core/design_system/`. Así todas las pantallas se ven como una sola app y en la sustentación se puede explicar cualquier parte.

```dart
import 'package:findu/core/design_system/design_system.dart';
```

Para verlo todo junto: en la app, **Pantallas del Sprint 1 → Ver el design system** (ruta `/dev/design-system`).

## Estilo: Liquid Glass, sin exagerar

- Fondo casi blanco (`#F4F4F4`) con dos brillos azules muy suaves (`FdBackground`).
- Tarjetas, campos, chips y barra inferior de **vidrio**: blanco translúcido, desenfoque de fondo, borde blanco fino y sombra suave (`FdGlass`).
- Un solo color de marca, el azul `#3AAFFE`. Los encabezados grandes usan el degradado `#F4F4F4 → #3AAFFE`.
- Títulos grandes en serif (Fraunces); todo lo demás en Inter para que se lea bien.
- Findi, la mascota, cambia de expresión según lo que pasa en la pantalla.

## Reglas

1. **Nada de colores, tamaños ni fuentes a mano.** Nada de `Color(0xFF...)`, `TextStyle(fontSize: 13)` ni `EdgeInsets.all(13)` en las pantallas. Se usan `FdColors`, `FdGradients`, `FdTypography`, `FdSpacing` y `FdRadius`. Si falta algo, se agrega al design system y se anota aquí.
2. **Si un componente ya existe, se usa.** Uno nuevo que se repita va en `components/` con el prefijo `Fd` y se anota en la tabla.
3. **El encabezado no se mueve.** Toda pantalla interna usa `FdScreenHeader`: el botón atrás, el título centrado y el ícono derecho siempre en el mismo lugar, aunque la pantalla no tenga ícono derecho.
4. **Una sola acción principal por pantalla.** Es el `FdButton` azul con degradado. Las demás son `secondary`, `danger` o `ghost`.
5. **Perdido es rojo, encontrado es azul.** Siempre con `FdBadge.status`, nunca con un color suelto.
6. **Toda lista tiene estado vacío** con Findi (`FdEmptyState`), y si carga datos, estado de carga y de error.
7. **El vidrio va donde ayuda.** Tarjetas, campos y barras. No se pone vidrio sobre vidrio ni desenfoque en fotos.
8. **Toques de al menos 44 × 44.** Los componentes ya lo cumplen.
9. **Textos en español y sin raya larga (—).**

## Tokens

### Colores (`FdColors`)

| Token | Hex | Para qué |
| --- | --- | --- |
| `background` | `#F4F4F4` | Fondo de todas las pantallas |
| `glass` / `glassStrong` | blanco 58 % / 80 % | Superficies de vidrio |
| `glassBorder` | blanco 90 % | Borde del vidrio |
| `border` | `#E5E7EB` | Divisores y bordes de controles |
| `primary` | `#3AAFFE` | Acción principal, selección, encontrado |
| `primaryLight` | `#6CC4FF` | Inicio del degradado de botones |
| `primarySoft` | `#E6F4FF` | Fondo de lo seleccionado y notas |
| `primaryDark` | `#1A5A99` | Texto sobre fondos azules claros |
| `textPrimary` | `#1E1E1E` | Texto principal |
| `textSecondary` | `#6B7280` | Texto de apoyo |
| `textDisabled` | `#A3A8B3` | Placeholders y deshabilitado |
| `lost` / `lostSoft` | `#DC3131` / `#FFE6E6` | Perdido, error, "Hubo un problema" |
| `warning` | `#E9A56B` | Encabezado de "Reporte enviado" |
| `success` | `#22A55A` | Respuesta correcta |

### Degradados (`FdGradients`)

| Token | Uso |
| --- | --- |
| `hero` | `#F4F4F4 → #3AAFFE`, encabezados de éxito y tarjeta de pregunta |
| `heroInverse` | `#3AAFFE → #9FD6FF`, Login (para que el título blanco se lea) |
| `problem` | Naranja suave, "Reporte enviado" |
| `button` | `#6CC4FF → #3AAFFE`, botón principal, segmento elegido y botón + |
| `mascot` | Cuerpo de Findi |

### Tipografía (`FdTypography`)

| Estilo | Fuente | Tamaño | Uso |
| --- | --- | --- | --- |
| `display` | Fraunces SemiBold | 34 | "¿Perdiste algo? Encuéntralo", "Mi perfil" |
| `h1` | Fraunces SemiBold | 28 | "¡Recibiste a Luna!", nombre en el detalle |
| `title` | Inter SemiBold | 20 | Título del encabezado: "Publicar objeto" |
| `h2` | Inter SemiBold | 18 | Sección: "Recientes" |
| `bodyStrong` | Inter SemiBold | 15 | Nombres, opciones |
| `body` | Inter | 15 | Texto normal |
| `button` | Inter SemiBold | 17 | Botones |
| `label` | Inter Medium | 12 | Etiqueta dentro de un campo |
| `caption` | Inter | 13 | Lugar, hora, ayudas |
| `overline` | Inter Bold | 11 | "ENTREGA VERIFICADA" |

### Espacios (`FdSpacing`) y radios (`FdRadius`)

- Espacios: `xxs 4 · xs 8 · sm 12 · md 16 · screen 20 · lg 24 · xl 32 · xxl 48`. El margen lateral de las pantallas es `screen`.
- Radios: `sm 10` · `md 18` (campos, filas) · `lg 26` (tarjetas de publicación) · `xl 32` (encabezados) · `sheet 32` · `pill` (botones, chips, segmentos, barra inferior).

## Findi (`FdMascot`)

Una nube de vidrio con solo ojos, juntos como un puffle. Se dibuja en código (`CustomPainter`), así no hay imágenes que exportar.

| `FdMood` | Ojos | Dónde |
| --- | --- | --- |
| `feliz` | Cerrados en arco | Login, registro, verificación aprobada, entrega verificada, publicado |
| `buscando` | Mirando a un lado | Elige tu universidad, mascota publicada, pantallas en construcción |
| `esperando` | Párpados a media altura | Solicitud pendiente de comunidad |
| `sorprendido` | Muy abiertos | Recuperar contraseña, impulso activo |
| `triste` | Párpados caídos | Verificación fallida, reporte enviado, errores |

## Componentes

| Componente | Para qué | Ejemplo en Figma |
| --- | --- | --- |
| `FdScaffold`, `FdBackground` | Fondo con brillos | Todas |
| `FdGlass` | Superficie de vidrio, con `selected` y `onTap` | Tarjetas, opciones |
| `FdButton` | `primary`, `secondary`, `danger`, `ghost`, con carga | "Publicar", "Hubo un problema" |
| `FdIconButton` | Botón redondo; puede llevar contador | Atrás, campana con 3 |
| `FdTextField` | Campo con etiqueta adentro; `isPassword` trae el ojo | Login, registro |
| `FdSegmented` | 2 a 3 opciones | Lo perdí / Lo encontré, Universitario / Ciudadano |
| `FdChip`, `FdChipBar`, `FdTag` | Filtros y etiquetas | Todo / Objetos / Mascotas, "Asustado" |
| `FdBadge.status` | Perdido, encontrado, verificado, pendiente, con problema | Tarjetas y detalle |
| `FdScreenHeader` | Atrás, título centrado y acción, siempre en el mismo lugar | Publicar objeto |
| `FdLargeTitle` | Título grande de pestaña | Inicio, Perfil |
| `FdSectionHeader` | Sección con "ver todo" | Recientes |
| `FdBottomNav` | Barra de vidrio con 4 pestañas y el botón + | Inicio, Explorar, +, Chats, Perfil |
| `FdPostCard` | Tarjeta de publicación con foto, estado y mapa | Luna, Mochila |
| `FdOptionCards` | Opciones tipo radio | Cómo unirse, motivos del problema |
| `FdSteps` | Progreso de 3 pasos | Preguntas 1 a 3 |
| `FdToggleRow` | Fila con interruptor | Configurar alertas |
| `FdInfoNote` | Nota azul informativa | "Toda comunidad tiene un administrador" |
| `FdListRow`, `FdAvatar` | Fila con avatar o ícono | Chats, métodos de pago |
| `FdResultHero` | Encabezado de éxito o problema con Findi | Entrega verificada, Reporte enviado |
| `showFdBottomSheet`, `FdSheetContent` | Hoja inferior de vidrio | S1 Confirmar entrega |
| `FdEmptyState`, `FdLoadingState`, `FdErrorState` | Estados de lista | Chats vacío |

## Datos de ejemplo

En el Sprint 1 solo se hace interfaz. Para que todas las pantallas cuenten la misma historia (Daniela, Luna, la mochila de Laura, la comunidad Bosques de Lili), se usa `lib/core/demo/demo_data.dart`. Las pantallas de detalle reciben el `id` de la publicación como argumento de la ruta y lo buscan con `DemoData.post(id)`. En el Sprint 2 eso se reemplaza por Supabase.
