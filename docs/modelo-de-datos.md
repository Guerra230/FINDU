# Modelo de datos de FINDU

Base de datos relacional para **Supabase (PostgreSQL)**. Cubre todos los casos de uso del prototipo: cuentas de universitarios y ciudadanos de varias universidades, comunidades con administrador (código de acceso o aprobación), publicaciones de objetos y mascotas, verificación del dueño, reporte de hallazgo, chat, entrega con doble confirmación, impulsos, recompensas y avisos.

- **26 tablas** (25 propias + `auth.users` de Supabase Auth)
- **49 relaciones** (llaves foráneas)
- **24 tipos enumerados**

La versión visual, con colores por dominio, está en Figma, página **Flujo**, debajo del diagrama de flujo:
https://www.figma.com/design/FAhwhJ4rkuyxYau3C3WYDR/Findu-%E2%80%93-Redise%C3%B1o-App?node-id=92-219

## Diagrama entidad-relación

```mermaid
erDiagram
    AUTH_USERS ||--|| PERFILES : es
    UNIVERSIDADES |o--o{ PERFILES : estudia
    UNIVERSIDADES |o--o| COMUNIDADES : tiene
    PERFILES ||--o{ COMUNIDADES : solicita
    COMUNIDADES ||--o{ MIEMBROS_COMUNIDAD : agrupa
    PERFILES ||--o{ MIEMBROS_COMUNIDAD : pertenece
    CODIGOS_ACCESO |o--o{ MIEMBROS_COMUNIDAD : usado_por
    PERFILES |o--o{ MIEMBROS_COMUNIDAD : aprueba
    COMUNIDADES ||--o{ CODIGOS_ACCESO : genera
    PERFILES ||--o{ CODIGOS_ACCESO : crea
    COMUNIDADES |o--o{ LUGARES : contiene
    PERFILES ||--o{ PUBLICACIONES : publica
    COMUNIDADES |o--o{ PUBLICACIONES : visibiliza
    CATEGORIAS ||--o{ PUBLICACIONES : clasifica
    LUGARES |o--o{ PUBLICACIONES : ubica
    PUBLICACIONES ||--o| DETALLES_OBJETO : detalla
    PUBLICACIONES ||--o| DETALLES_MASCOTA : detalla
    PUBLICACIONES |o--o{ FOTOS : tiene
    REPORTES_HALLAZGO |o--o{ FOTOS : adjunta
    PUBLICACIONES ||--o{ REPORTES_HALLAZGO : recibe
    PERFILES ||--o{ REPORTES_HALLAZGO : reporta
    PUBLICACIONES ||--o{ PREGUNTAS_VERIFICACION : protege
    PUBLICACIONES ||--o{ INTENTOS_VERIFICACION : recibe
    PERFILES ||--o{ INTENTOS_VERIFICACION : intenta
    INTENTOS_VERIFICACION ||--|{ RESPUESTAS : contiene
    PREGUNTAS_VERIFICACION ||--o{ RESPUESTAS : responde
    PUBLICACIONES ||--o{ CONVERSACIONES : origina
    INTENTOS_VERIFICACION |o--o| CONVERSACIONES : abre
    REPORTES_HALLAZGO |o--o| CONVERSACIONES : abre
    PERFILES ||--o{ CONVERSACIONES : dueno
    PERFILES ||--o{ CONVERSACIONES : contraparte
    CONVERSACIONES ||--o{ MENSAJES : contiene
    PERFILES ||--o{ MENSAJES : envia
    CONVERSACIONES ||--o| ENTREGAS : cierra
    PUBLICACIONES ||--o{ ENTREGAS : concluye
    PUBLICACIONES ||--o{ IMPULSOS : impulsa
    PLANES_IMPULSO ||--o{ IMPULSOS : define
    PAGOS ||--o| IMPULSOS : activa
    PERFILES ||--o{ METODOS_PAGO : registra
    PERFILES ||--o{ PAGOS : paga
    METODOS_PAGO ||--o{ PAGOS : usa
    PUBLICACIONES ||--o{ PAGOS : asociado
    ENTREGAS |o--o| PAGOS : libera
    PERFILES |o--o{ PAGOS : beneficiario
    PERFILES ||--o{ NOTIFICACIONES : recibe
    PUBLICACIONES |o--o{ NOTIFICACIONES : refiere
    CONVERSACIONES |o--o{ NOTIFICACIONES : refiere
    PERFILES ||--|| AJUSTES_NOTIFICACION : configura
    PERFILES ||--o{ DISPOSITIVOS : usa

    AUTH_USERS {
        uuid id PK
        text email UK
        text encrypted_password
        timestamptz email_confirmed_at
    }
    PERFILES {
        uuid id PK,FK "igual a auth.users.id"
        uuid universidad_id FK "nulo si es ciudadano"
        text nombre
        text correo UK "nulo si es ciudadano"
        text celular UK "nulo si es universitario"
        tipo_cuenta tipo_cuenta
        text codigo_estudiantil
        text foto_url
        boolean acepto_terminos
        timestamptz creado_en
    }
    UNIVERSIDADES {
        uuid id PK
        text nombre
        text dominio_correo UK "u.icesi.edu.co"
        text ciudad
    }
    COMUNIDADES {
        uuid id PK
        uuid universidad_id FK,UK
        uuid creada_por FK
        text nombre
        tipo_comunidad tipo
        text direccion
        text evidencia_url
        estado_comunidad estado
        timestamptz revisada_en
        timestamptz creado_en
    }
    MIEMBROS_COMUNIDAD {
        uuid id PK
        uuid comunidad_id FK
        uuid perfil_id FK
        rol_miembro rol
        metodo_ingreso metodo_ingreso
        uuid codigo_id FK
        estado_membresia estado
        uuid aprobado_por FK
        boolean es_activa
        timestamptz solicitado_en
        timestamptz unido_en
    }
    CODIGOS_ACCESO {
        uuid id PK
        uuid comunidad_id FK
        uuid creado_por FK
        text codigo UK "LILI-4821"
        smallint usos_maximos
        smallint usos_actuales
        timestamptz vence_en
        boolean activo
    }
    LUGARES {
        uuid id PK
        uuid comunidad_id FK
        text nombre
        tipo_lugar tipo
        numeric latitud
        numeric longitud
    }
    CATEGORIAS {
        uuid id PK
        text nombre
        tipo_publicacion tipo
    }
    PUBLICACIONES {
        uuid id PK
        uuid autor_id FK
        uuid comunidad_id FK "nulo es pública"
        uuid categoria_id FK
        uuid lugar_id FK
        tipo_publicacion tipo
        intencion intencion
        text titulo
        text descripcion
        estado_publicacion estado
        numeric latitud
        numeric longitud
        timestamptz ultima_vez_visto
        integer recompensa_cop "solo si es perdido"
        timestamptz creado_en
        timestamptz actualizado_en
    }
    DETALLES_OBJETO {
        uuid publicacion_id PK,FK
        text color
        text marca
    }
    DETALLES_MASCOTA {
        uuid publicacion_id PK,FK
        text nombre
        especie especie
        text raza
        text edad
        tamano tamano
    }
    FOTOS {
        uuid id PK
        uuid publicacion_id FK
        uuid reporte_id FK
        text url "Supabase Storage"
        tipo_foto tipo
        smallint orden
    }
    REPORTES_HALLAZGO {
        uuid id PK
        uuid publicacion_id FK
        uuid reportado_por FK
        donde_esta donde_esta
        estado_hallazgo estado_hallazgo
        numeric latitud
        numeric longitud
        timestamptz creado_en
    }
    PREGUNTAS_VERIFICACION {
        uuid id PK
        uuid publicacion_id FK
        text texto
        text respuesta_hash
        smallint orden
    }
    INTENTOS_VERIFICACION {
        uuid id PK
        uuid publicacion_id FK
        uuid solicitante_id FK
        smallint numero "máximo 2"
        estado_intento estado
        timestamptz creado_en
        timestamptz resuelto_en
    }
    RESPUESTAS {
        uuid id PK
        uuid intento_id FK
        uuid pregunta_id FK
        text texto
        boolean es_correcta
    }
    CONVERSACIONES {
        uuid id PK
        uuid publicacion_id FK
        uuid intento_id FK,UK
        uuid reporte_id FK,UK
        uuid dueno_id FK
        uuid contraparte_id FK
        estado_conversacion estado
        timestamptz abierta_en
    }
    MENSAJES {
        uuid id PK
        uuid conversacion_id FK
        uuid emisor_id FK
        text contenido
        text adjunto_url
        timestamptz leido_en
        timestamptz enviado_en
    }
    ENTREGAS {
        uuid id PK
        uuid conversacion_id FK,UK
        uuid publicacion_id FK
        estado_entrega estado
        timestamptz confirmo_dueno_en
        timestamptz confirmo_contraparte_en
        motivo_problema motivo_problema
        text detalle_problema
        timestamptz creado_en
    }
    PLANES_IMPULSO {
        uuid id PK
        text nombre UK "Básico o Destacado"
        integer precio_cop
        smallint radio_km
        integer alcance_personas
        smallint duracion_horas
    }
    IMPULSOS {
        uuid id PK
        uuid publicacion_id FK
        uuid plan_id FK
        uuid pago_id FK,UK
        timestamptz inicia_en
        timestamptz termina_en
    }
    METODOS_PAGO {
        uuid id PK
        uuid perfil_id FK
        proveedor_pago proveedor
        text token_pasarela
        text ultimos4
        boolean predeterminado
    }
    PAGOS {
        uuid id PK
        uuid perfil_id FK
        uuid metodo_pago_id FK
        uuid publicacion_id FK
        uuid entrega_id FK,UK
        uuid beneficiario_id FK
        concepto_pago concepto
        integer monto_cop
        estado_pago estado
        timestamptz creado_en
    }
    NOTIFICACIONES {
        uuid id PK
        uuid perfil_id FK
        uuid publicacion_id FK
        uuid conversacion_id FK
        tipo_notificacion tipo
        text titulo
        text cuerpo
        timestamptz leida_en
        timestamptz creado_en
    }
    AJUSTES_NOTIFICACION {
        uuid perfil_id PK,FK
        boolean cerca_de_mi
        boolean mis_publicaciones
        boolean comunidades
        boolean mensajes
        boolean pagos
        boolean novedades
        smallint radio_km
        numeric latitud_base
        numeric longitud_base
    }
    DISPOSITIVOS {
        uuid id PK
        uuid perfil_id FK
        text token_push UK
        plataforma plataforma
        timestamptz ultimo_uso
    }
```

## Reglas del modelo

1. **Cuenta:** `perfiles.id` es el mismo id de `auth.users` (borrado en cascada). La contraseña solo vive en Supabase Auth.
2. **Tipo de cuenta:** el universitario usa el correo de una universidad registrada y su código estudiantil. El ciudadano usa celular. Siempre hay correo o celular.
3. **Varias universidades:** la universidad se elige o se detecta por `universidades.dominio_correo`. Cada universidad tiene su comunidad.
4. **Siempre hay admin:** al aprobarse una comunidad, su creador queda como miembro con rol `admin`. No puede salir el último admin.
5. **Ingreso a una comunidad:** solo con código de acceso o con aprobación de un admin. El correo institucional prueba la universidad, pero no da ingreso automático.
6. **Código de acceso:** es válido si está activo, no ha vencido y `usos_actuales < usos_maximos`. Al usarlo, el miembro queda aprobado y el código suma un uso.
7. **Solicitud de ingreso:** queda `pendiente` hasta que un admin la acepta o la rechaza. `aprobado_por` guarda quién decidió.
8. **Comunidad nueva:** queda `en_revision` hasta que el equipo FINDU aprueba la evidencia (acta, NIT o dominio).
9. **Comunidad activa:** cada perfil tiene una sola (índice único parcial sobre `perfil_id` donde `es_activa`).
10. **Detalle según tipo:** un objeto tiene `detalles_objeto` y una mascota tiene `detalles_mascota`, nunca los dos. La recompensa solo aplica si la intención es `perdido`.
11. **Preguntas privadas:** toda publicación `encontrado` tiene 3 preguntas. La respuesta se guarda como hash y nunca se muestra.
12. **Intentos:** máximo 2 por solicitante y publicación. Se aprueba solo con las 3 respuestas correctas.
13. **Abrir chat:** solo con un intento aprobado (algo encontrado) o con un reporte de hallazgo (algo perdido).
14. **Punto de encuentro:** no se guarda en ninguna tabla. Lo acuerdan los usuarios en los mensajes del chat.
15. **Doble confirmación:** la entrega queda `confirmada` cuando los dos marcan su confirmación. Entonces la publicación pasa a `entregada` y la recompensa pasa de `retenido` a `liberado`.
16. **Hubo un problema:** la entrega pasa a `con_problema` con su motivo. La publicación vuelve a `activa`, la recompensa sigue retenida y el chat sigue abierto.
17. **Impulso:** se activa cuando su pago se confirma. `termina_en = inicia_en + duracion_horas` del plan.
18. **Pagos seguros:** nunca se guardan números de tarjeta ni de cuenta, solo el token de la pasarela y los últimos 4 dígitos.
19. **Borrado:** borrar una publicación borra en cascada sus detalles, fotos, preguntas, intentos y notificaciones. Las conversaciones y los pagos se conservan como historial.
20. **Seguridad (RLS):** cada usuario solo lee y escribe sus filas (`auth.uid()`). Las publicaciones se leen si son públicas o de una comunidad donde es miembro aprobado.

## Datos que se calculan (no se guardan)

| Dato | Cómo se obtiene |
| --- | --- |
| Contadores del perfil (devueltos, publicados, perdidos) | Conteo de publicaciones del autor por estado e intención |
| Miembros de una comunidad | Conteo de `miembros_comunidad` aprobados |
| Usos restantes de un código | `usos_maximos − usos_actuales` |
| Distancia "a 300 m" | Distancia entre el usuario y la publicación (PostGIS o Haversine) |
| "Hace 1 h" | `now() − creado_en` o `ultima_vez_visto` |
| Intentos restantes | `2 −` intentos del solicitante en esa publicación |
| Vecinos alertados | Perfiles con alertas activas dentro del radio |
| Tiempo restante del impulso | `termina_en − now()` |
| No leídos | Notificaciones y mensajes con `leida_en` / `leido_en` nulo |
| "Laura ya confirmó" | `confirmo_dueno_en` y `confirmo_contraparte_en` de la entrega |

## Cobertura de casos de uso

| Pantallas (número en Figma) | Tablas |
| --- | --- |
| 01 Login · 02-04 Registro · 03 Elige tu universidad | `auth.users`, `perfiles`, `universidades` |
| 05-07 Recuperar contraseña | `auth.users` (Supabase Auth) |
| 08 Inicio · 09 Explorar · 10 Mapa · 19 Detalle | `publicaciones`, `categorias`, `fotos`, `lugares`, `detalles_objeto`, `detalles_mascota` |
| 13-15 Publicar objeto o mascota · 16 Compartir | `publicaciones`, detalles, `fotos`, `preguntas_verificacion`, `notificaciones` |
| 17-18 Impulsar | `planes_impulso`, `impulsos`, `pagos`, `metodos_pago` |
| 20-23 Verificación | `preguntas_verificacion`, `intentos_verificacion`, `respuestas` |
| 24 Encontré a… | `reportes_hallazgo`, `fotos` |
| 25-26 Chats y chat | `conversaciones`, `mensajes` |
| S1 Confirmar entrega · 27-29 Problema y entrega verificada | `entregas`, `pagos`, `publicaciones` |
| 30-35 Comunidades y panel admin | `comunidades`, `miembros_comunidad`, `codigos_acceso` |
| 11 Notificaciones · 12 Configurar alertas | `notificaciones`, `ajustes_notificacion`, `dispositivos` |
| 36 Perfil · 37 Métodos de pago | `perfiles`, `publicaciones`, `metodos_pago` |

## Tipos enumerados

| Tipo | Valores |
| --- | --- |
| `tipo_cuenta` | universitario, ciudadano |
| `tipo_comunidad` | educativa, residencial, corporativa, publica, evento |
| `estado_comunidad` | en_revision, activa, rechazada |
| `rol_miembro` | miembro, admin |
| `metodo_ingreso` | codigo, aprobacion, creador |
| `estado_membresia` | pendiente, aprobado, rechazado |
| `tipo_lugar` | campus, barrio |
| `tipo_publicacion` | objeto, mascota |
| `intencion` | perdido, encontrado |
| `estado_publicacion` | activa, en_verificacion, entregada, cerrada |
| `especie` | perro, gato, otro |
| `tamano` | pequeno, mediano, grande |
| `tipo_foto` | general, cara, cuerpo |
| `estado_intento` | pendiente, aprobado, rechazado |
| `donde_esta` | conmigo, veterinaria, porteria, otro |
| `estado_hallazgo` | buen_estado, asustado, herido, danado, otro |
| `estado_conversacion` | abierta, cerrada |
| `estado_entrega` | pendiente, confirmada, con_problema |
| `motivo_problema` | no_era, no_llego, sin_acuerdo, otro |
| `proveedor_pago` | nequi, tarjeta |
| `concepto_pago` | impulso, tarifa, recompensa |
| `estado_pago` | pendiente, retenido, liberado, reembolsado |
| `tipo_notificacion` | avistamiento, verificacion, cercana, mensaje, reencuentro, recompensa, comunidad, impulso |
| `plataforma` | ios, android |
