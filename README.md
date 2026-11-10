# FINDU

App para encontrar objetos y mascotas perdidas dentro de comunidades: universidades, conjuntos, empresas o barrios. Quien encuentra algo lo publica con preguntas privadas; el dueño las responde para demostrar que es suyo, hablan por el chat, acuerdan dónde verse y confirman la entrega entre los dos.

Proyecto final de **Aplicaciones Móviles** · Universidad Icesi · 2026-2. Lo desarrolla **Juan** (proyecto individual).

## Stack

- **App:** Flutter, con Clean Architecture y Bloc (`flutter_bloc`)
- **Backend:** Supabase (Auth, PostgreSQL con RLS, Storage para fotos)
- **Diseño:** prototipo interactivo en Figma, estilo Liquid Glass con la mascota Findi

## Enlaces

- Diseño y prototipo (página **App corregida**, flujo **FINDU Liquid Glass**): https://www.figma.com/design/FAhwhJ4rkuyxYau3C3WYDR
- Flujo de la app y modelo de datos: página **Flujo** del mismo archivo, y en el repo [docs/modelo-de-datos.md](docs/modelo-de-datos.md)

## Entregas

| Fecha | Entrega | Sustentación |
| --- | --- | --- |
| 27 oct | Sprint 1: interfaz | Presencial |
| 10 nov | Sprint 2: Supabase y Bloc | Presencial |
| 24 nov | Sprint 3 | Virtual |
| 30 nov | Entrega final | El profesor usa la app |

## Cómo correrlo

```bash
git clone https://github.com/Guerra230/FINDU.git
cd FINDU
flutter pub get
cp env.example.json env.json
flutter run --dart-define-from-file=env.json
```

Antes hay que crear el proyecto de Supabase y llenar `env.json` con la URL y la anon key. Los pasos están en [docs/supabase.md](docs/supabase.md).

## Estructura

```
lib/
  core/design_system/   tokens, tema, componentes Fd y Findi (ver docs/design-system.md)
  core/navigation/      rutas, barra inferior y pantallas temporales
  core/demo/            datos de ejemplo de comunidades e impulsos
  core/models/          modelo Post compartido entre features
  core/supabase/        inicialización del cliente
  core/dev/             índice de pantallas para desarrollo
  features/<feature>/   domain, data y ui (bloc, screens, widgets) por cada parte de la app
supabase/migrations/    esquema SQL, RLS, funciones y datos iniciales
docs/                   design system, plan del sprint, flujo de Git y prompt para IA
```

## Documentos

- [**Modelo de datos**](docs/modelo-de-datos.md)
- [**Supabase: configuración**](docs/supabase.md)
- [Design system](docs/design-system.md)
- [Sprint 1: plan y pantallas](docs/sprint-1/plan.md)
- [Cómo trabajo con Git](docs/flujo-git.md)
- [Prompt para usar IA sin dañar el proyecto](docs/prompt-ia.md)

---

Este trabajo fue apoyado con herramientas de inteligencia artificial.
