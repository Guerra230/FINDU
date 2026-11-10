# Supabase en FINDU

## 1. Crear el proyecto

1. Entra a https://supabase.com y crea una cuenta con tu GitHub.
2. **New project** → nombre `findu`, región **East US (North Virginia)** o **South America (São Paulo)**, y guarda la contraseña de la base de datos.
3. Espera a que termine de crearse (1 o 2 minutos).

## 2. Crear las tablas

1. En el menú izquierdo abre **SQL Editor** → **New query**.
2. Copia todo el archivo `supabase/migrations/20261102000000_esquema_findu.sql`, pégalo y dale **Run**.
3. Debe decir `Success. No rows returned`. En **Table Editor** deben aparecer las 26 tablas.

## 3. Configurar Auth

En **Authentication** → **Sign In / Providers** → **Email**:

- Desactiva **Confirm email**. Las cuentas ciudadanas usan un correo interno (`<celular>@ciudadano.findu.app`) que no recibe mensajes.

La recuperación de contraseña manda un código de 6 dígitos al correo. Para que llegue a cualquier correo hay que configurar un SMTP propio (por ejemplo Resend, gratis) en **Authentication** → **Emails** → **SMTP Settings**, y en la plantilla **Reset password** poner:

```html
<h2>Recupera tu contraseña de FINDU</h2>
<p>Tu código es: <strong>{{ .Token }}</strong></p>
```

Sin SMTP propio, Supabase solo envía correos a los miembros del proyecto.

## 4. Conectar la app

1. En **Project Settings** → **API** copia **Project URL** y la llave **anon public**.
2. En la raíz del proyecto copia `env.example.json` como `env.json` y pega los dos valores.
3. `env.json` está en `.gitignore`, así que no se sube a GitHub.
4. Corre la app con:

```bash
flutter run --dart-define-from-file=env.json
```

Si se te olvida el `--dart-define-from-file`, la app muestra la pantalla "Falta configurar Supabase".

## Qué quedó conectado en el Sprint 2

| Parte | Cómo funciona |
| --- | --- |
| Registro e inicio de sesión | Supabase Auth. Un trigger crea el perfil en `perfiles` con los datos del registro |
| Recuperar contraseña | Código de 6 dígitos al correo (`verifyOTP` tipo recovery) |
| Publicar objeto o mascota | Inserta en `publicaciones`, `detalles_*`, sube fotos al bucket `fotos` y guarda las preguntas con la respuesta cifrada (`agregar_pregunta`) |
| Inicio, explorar y mapa | Lee `publicaciones` activas con autor, categoría, lugar y fotos |
| Verificar que es tuyo | `verificar_respuestas` compara las respuestas en la base de datos, máximo 2 intentos, y abre el chat si aprueba |
| Lo encontré | `reportar_hallazgo` guarda el reporte con fotos y abre el chat |
| Chat | Tabla `mensajes` en tiempo real (Realtime) |
| Entrega | `confirmar_entrega` necesita la confirmación de los dos; `reportar_problema` reactiva la publicación |
| Notificaciones | Tabla `notificaciones`, se marcan como leídas |

Comunidades, impulsos y pagos siguen con datos de ejemplo (`lib/core/demo/demo_data.dart`) y se conectan en el Sprint 3.

## Seguridad

- Todas las tablas tienen Row Level Security.
- Las respuestas de verificación se guardan con `crypt()` y la app nunca puede leerlas: la columna `respuesta_hash` no tiene permiso de lectura.
- Cada usuario solo puede subir fotos dentro de su carpeta (`fotos/<id del usuario>/...`).
