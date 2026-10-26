# FINDU

App para encontrar objetos y mascotas perdidas dentro de comunidades: universidades, conjuntos, empresas o barrios. Quien encuentra algo lo publica con preguntas privadas; el dueño las responde para demostrar que es suyo, hablan por el chat, acuerdan dónde verse y confirman la entrega entre los dos.

Proyecto final de **Aplicaciones Móviles** · Universidad Icesi · 2026-2. Lo desarrolla **Juan** (proyecto individual).

## Stack

- **App:** Flutter, con Clean Architecture y Bloc (`flutter_bloc`)
- **Backend:** Supabase (Auth, PostgreSQL con RLS, Storage para fotos)
- **Diseño:** prototipo interactivo en Figma, estilo Liquid Glass con la mascota Findi

## Enlaces

- Diseño y prototipo (página **App corregida**, flujo **FINDU Liquid Glass**): https://www.figma.com/design/FAhwhJ4rkuyxYau3C3WYDR
- Flujo de la app y modelo de datos: página **Flujo** del mismo archivo

## Entregas

| Fecha | Entrega | Sustentación |
| --- | --- | --- |
| 27 oct | Sprint 1: interfaz | Presencial |
| 10 nov | Sprint 2: Supabase y Bloc | Presencial |
| 24 nov | Sprint 3 | Virtual |
| 30 nov | Entrega final | El profesor usa la app |

## Cómo correrlo

```bash
git clone https://github.com/<tu-usuario>/findu.git
cd findu
flutter create . --org co.edu.icesi --project-name findu --platforms=android,ios
flutter pub get
flutter run
```

`flutter create .` solo se corre la primera vez: crea las carpetas de Android e iOS y no toca `lib/`.

Al abrir la app, cualquier pantalla en construcción tiene el botón **Ver todas las pantallas**, que lleva al índice de pantallas y a la galería del design system.

## Estructura

```
lib/
  core/design_system/   tokens, tema, componentes Fd y Findi (ver docs/design-system.md)
  core/navigation/      rutas, barra inferior y pantallas temporales
  core/demo/            datos de ejemplo del Sprint 1
  core/dev/             índice de pantallas para desarrollo
  features/<feature>/   una carpeta por parte de la app (auth, publish, chat...)
docs/                   design system, plan del sprint, flujo de Git y prompt para IA
```

## Documentos

- [Design system](docs/design-system.md)
- [Sprint 1: plan y pantallas](docs/sprint-1/plan.md)
- [Cómo trabajo con Git](docs/flujo-git.md)
- [Prompt para usar IA sin dañar el proyecto](docs/prompt-ia.md)

---

Este trabajo fue apoyado con herramientas de inteligencia artificial.
