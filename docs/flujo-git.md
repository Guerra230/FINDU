# Cómo trabajo con Git

El profesor califica la calidad de los commits, no la cantidad. Aunque el proyecto es individual, trabajo igual que en equipo: una rama por parte, un commit por pantalla y Pull Request a `main`.

## Una vez

```bash
git clone https://github.com/<tu-usuario>/findu.git
cd findu
flutter create . --org co.edu.icesi --project-name findu --platforms=android,ios
flutter pub get
git config user.name "Juan ..."
git config user.email "correo-de-tu-cuenta-de-github"
```

## Cada parte del sprint

```bash
git checkout main
git pull
git checkout -b feature/acceso
```

Ramas del Sprint 1, en este orden:

1. `feature/acceso`
2. `feature/inicio-explorar`
3. `feature/publicar`
4. `feature/verificacion-chat`
5. `feature/comunidades-perfil`

## Commits

- Uno por cosa terminada: una pantalla, un componente, un arreglo.
- El mensaje dice qué hice, empezando por el tipo:
  - `feat: pantalla de login con correo o celular`
  - `fix: el encabezado se movía al cambiar de pantalla`
  - `refactor: FdPostCard en Explorar`
  - `docs: flujo de verificación del dueño`

```bash
git add lib/features/auth
git commit -m "feat: pantalla de login con correo o celular"
git push -u origin feature/acceso
```

## Pull Request

1. En GitHub abro un **Pull Request** de la rama a `main`.
2. Me reviso con esta lista antes de unir:
   - `flutter analyze` sin errores.
   - La pantalla se ve como en Figma y navega a donde debe.
   - No hay colores, tamaños ni fuentes a mano.
   - Solo cambié la carpeta de esa feature y su archivo de rutas.
3. Uno con **Create a merge commit**, no con "Squash", para que queden todos los commits.

## Antes de cada sustentación

Repaso todo el código: el profe pregunta por cualquier parte.
