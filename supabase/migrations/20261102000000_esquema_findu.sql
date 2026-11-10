create extension if not exists pgcrypto with schema extensions;

create type tipo_cuenta as enum ('universitario', 'ciudadano');
create type tipo_comunidad as enum ('educativa', 'residencial', 'corporativa', 'publica', 'evento');
create type estado_comunidad as enum ('en_revision', 'activa', 'rechazada');
create type rol_miembro as enum ('miembro', 'admin');
create type metodo_ingreso as enum ('codigo', 'aprobacion', 'creador');
create type estado_membresia as enum ('pendiente', 'aprobado', 'rechazado');
create type tipo_lugar as enum ('campus', 'barrio');
create type tipo_publicacion as enum ('objeto', 'mascota');
create type intencion as enum ('perdido', 'encontrado');
create type estado_publicacion as enum ('activa', 'en_verificacion', 'entregada', 'cerrada');
create type especie as enum ('perro', 'gato', 'otro');
create type tamano as enum ('pequeno', 'mediano', 'grande');
create type tipo_foto as enum ('general', 'cara', 'cuerpo');
create type estado_intento as enum ('pendiente', 'aprobado', 'rechazado');
create type donde_esta as enum ('conmigo', 'veterinaria', 'porteria', 'otro');
create type estado_hallazgo as enum ('buen_estado', 'asustado', 'herido', 'danado', 'otro');
create type estado_conversacion as enum ('abierta', 'cerrada');
create type estado_entrega as enum ('pendiente', 'confirmada', 'con_problema');
create type motivo_problema as enum ('no_era', 'no_llego', 'sin_acuerdo', 'otro');
create type proveedor_pago as enum ('nequi', 'tarjeta');
create type concepto_pago as enum ('impulso', 'tarifa', 'recompensa');
create type estado_pago as enum ('pendiente', 'retenido', 'liberado', 'reembolsado');
create type tipo_notificacion as enum ('avistamiento', 'verificacion', 'cercana', 'mensaje', 'reencuentro', 'recompensa', 'comunidad', 'impulso');
create type plataforma as enum ('ios', 'android');

create table universidades (
  id uuid primary key default gen_random_uuid(),
  nombre text not null,
  dominio_correo text not null unique,
  ciudad text not null default 'Cali'
);

create table perfiles (
  id uuid primary key references auth.users (id) on delete cascade,
  universidad_id uuid references universidades (id),
  nombre text not null,
  correo text unique,
  celular text unique,
  tipo_cuenta tipo_cuenta not null,
  codigo_estudiantil text,
  foto_url text,
  acepto_terminos boolean not null default false,
  creado_en timestamptz not null default now(),
  check (correo is not null or celular is not null)
);

create table comunidades (
  id uuid primary key default gen_random_uuid(),
  universidad_id uuid unique references universidades (id),
  creada_por uuid not null references perfiles (id),
  nombre text not null,
  tipo tipo_comunidad not null,
  direccion text,
  evidencia_url text,
  estado estado_comunidad not null default 'en_revision',
  revisada_en timestamptz,
  creado_en timestamptz not null default now()
);

create table codigos_acceso (
  id uuid primary key default gen_random_uuid(),
  comunidad_id uuid not null references comunidades (id) on delete cascade,
  creado_por uuid not null references perfiles (id),
  codigo text not null unique,
  usos_maximos smallint not null default 20,
  usos_actuales smallint not null default 0,
  vence_en timestamptz not null,
  activo boolean not null default true,
  check (usos_actuales <= usos_maximos)
);

create table miembros_comunidad (
  id uuid primary key default gen_random_uuid(),
  comunidad_id uuid not null references comunidades (id) on delete cascade,
  perfil_id uuid not null references perfiles (id) on delete cascade,
  rol rol_miembro not null default 'miembro',
  metodo_ingreso metodo_ingreso not null,
  codigo_id uuid references codigos_acceso (id),
  estado estado_membresia not null default 'pendiente',
  aprobado_por uuid references perfiles (id),
  es_activa boolean not null default false,
  solicitado_en timestamptz not null default now(),
  unido_en timestamptz,
  unique (comunidad_id, perfil_id)
);

create unique index una_comunidad_activa on miembros_comunidad (perfil_id) where es_activa;

create table lugares (
  id uuid primary key default gen_random_uuid(),
  comunidad_id uuid references comunidades (id) on delete cascade,
  nombre text not null,
  tipo tipo_lugar not null,
  latitud numeric(9, 6) not null,
  longitud numeric(9, 6) not null
);

create table categorias (
  id uuid primary key default gen_random_uuid(),
  nombre text not null,
  tipo tipo_publicacion not null,
  unique (nombre, tipo)
);

create table publicaciones (
  id uuid primary key default gen_random_uuid(),
  autor_id uuid not null references perfiles (id) on delete cascade,
  comunidad_id uuid references comunidades (id),
  categoria_id uuid not null references categorias (id),
  lugar_id uuid references lugares (id),
  tipo tipo_publicacion not null,
  intencion intencion not null,
  titulo text not null,
  descripcion text,
  estado estado_publicacion not null default 'activa',
  latitud numeric(9, 6) not null,
  longitud numeric(9, 6) not null,
  ultima_vez_visto timestamptz not null default now(),
  recompensa_cop integer check (recompensa_cop is null or recompensa_cop >= 0),
  creado_en timestamptz not null default now(),
  actualizado_en timestamptz not null default now(),
  check (recompensa_cop is null or intencion = 'perdido')
);

create index publicaciones_recientes on publicaciones (creado_en desc);

create table detalles_objeto (
  publicacion_id uuid primary key references publicaciones (id) on delete cascade,
  color text,
  marca text
);

create table detalles_mascota (
  publicacion_id uuid primary key references publicaciones (id) on delete cascade,
  nombre text,
  especie especie not null,
  raza text,
  edad text,
  tamano tamano
);

create table reportes_hallazgo (
  id uuid primary key default gen_random_uuid(),
  publicacion_id uuid not null references publicaciones (id) on delete cascade,
  reportado_por uuid not null references perfiles (id),
  donde_esta donde_esta not null,
  estado_hallazgo estado_hallazgo not null,
  latitud numeric(9, 6),
  longitud numeric(9, 6),
  creado_en timestamptz not null default now()
);

create table fotos (
  id uuid primary key default gen_random_uuid(),
  publicacion_id uuid references publicaciones (id) on delete cascade,
  reporte_id uuid references reportes_hallazgo (id) on delete cascade,
  url text not null,
  tipo tipo_foto not null default 'general',
  orden smallint not null default 1,
  check (publicacion_id is not null or reporte_id is not null)
);

create table preguntas_verificacion (
  id uuid primary key default gen_random_uuid(),
  publicacion_id uuid not null references publicaciones (id) on delete cascade,
  texto text not null,
  respuesta_hash text not null,
  orden smallint not null
);

create table intentos_verificacion (
  id uuid primary key default gen_random_uuid(),
  publicacion_id uuid not null references publicaciones (id) on delete cascade,
  solicitante_id uuid not null references perfiles (id),
  numero smallint not null check (numero between 1 and 2),
  estado estado_intento not null default 'pendiente',
  creado_en timestamptz not null default now(),
  resuelto_en timestamptz,
  unique (publicacion_id, solicitante_id, numero)
);

create table respuestas (
  id uuid primary key default gen_random_uuid(),
  intento_id uuid not null references intentos_verificacion (id) on delete cascade,
  pregunta_id uuid not null references preguntas_verificacion (id) on delete cascade,
  texto text not null,
  es_correcta boolean not null
);

create table conversaciones (
  id uuid primary key default gen_random_uuid(),
  publicacion_id uuid not null references publicaciones (id),
  intento_id uuid unique references intentos_verificacion (id),
  reporte_id uuid unique references reportes_hallazgo (id),
  dueno_id uuid not null references perfiles (id),
  contraparte_id uuid not null references perfiles (id),
  estado estado_conversacion not null default 'abierta',
  abierta_en timestamptz not null default now(),
  check (dueno_id <> contraparte_id)
);

create table mensajes (
  id uuid primary key default gen_random_uuid(),
  conversacion_id uuid not null references conversaciones (id) on delete cascade,
  emisor_id uuid not null references perfiles (id),
  contenido text not null check (length(trim(contenido)) > 0),
  adjunto_url text,
  leido_en timestamptz,
  enviado_en timestamptz not null default now()
);

create index mensajes_por_chat on mensajes (conversacion_id, enviado_en);

create table entregas (
  id uuid primary key default gen_random_uuid(),
  conversacion_id uuid not null unique references conversaciones (id),
  publicacion_id uuid not null references publicaciones (id),
  estado estado_entrega not null default 'pendiente',
  confirmo_dueno_en timestamptz,
  confirmo_contraparte_en timestamptz,
  motivo_problema motivo_problema,
  detalle_problema text,
  creado_en timestamptz not null default now()
);

create table planes_impulso (
  id uuid primary key default gen_random_uuid(),
  nombre text not null unique,
  precio_cop integer not null,
  radio_km smallint not null,
  alcance_personas integer not null,
  duracion_horas smallint not null
);

create table metodos_pago (
  id uuid primary key default gen_random_uuid(),
  perfil_id uuid not null references perfiles (id) on delete cascade,
  proveedor proveedor_pago not null,
  token_pasarela text not null,
  ultimos4 text not null check (length(ultimos4) = 4),
  predeterminado boolean not null default false
);

create table pagos (
  id uuid primary key default gen_random_uuid(),
  perfil_id uuid not null references perfiles (id),
  metodo_pago_id uuid not null references metodos_pago (id),
  publicacion_id uuid not null references publicaciones (id),
  entrega_id uuid unique references entregas (id),
  beneficiario_id uuid references perfiles (id),
  concepto concepto_pago not null,
  monto_cop integer not null check (monto_cop > 0),
  estado estado_pago not null default 'pendiente',
  creado_en timestamptz not null default now()
);

create table impulsos (
  id uuid primary key default gen_random_uuid(),
  publicacion_id uuid not null references publicaciones (id) on delete cascade,
  plan_id uuid not null references planes_impulso (id),
  pago_id uuid not null unique references pagos (id),
  inicia_en timestamptz,
  termina_en timestamptz
);

create table notificaciones (
  id uuid primary key default gen_random_uuid(),
  perfil_id uuid not null references perfiles (id) on delete cascade,
  publicacion_id uuid references publicaciones (id) on delete cascade,
  conversacion_id uuid references conversaciones (id) on delete cascade,
  tipo tipo_notificacion not null,
  titulo text not null,
  cuerpo text not null,
  leida_en timestamptz,
  creado_en timestamptz not null default now()
);

create table ajustes_notificacion (
  perfil_id uuid primary key references perfiles (id) on delete cascade,
  cerca_de_mi boolean not null default true,
  mis_publicaciones boolean not null default true,
  comunidades boolean not null default true,
  mensajes boolean not null default true,
  pagos boolean not null default true,
  novedades boolean not null default false,
  radio_km smallint not null default 1,
  latitud_base numeric(9, 6),
  longitud_base numeric(9, 6)
);

create table dispositivos (
  id uuid primary key default gen_random_uuid(),
  perfil_id uuid not null references perfiles (id) on delete cascade,
  token_push text not null unique,
  plataforma plataforma not null,
  ultimo_uso timestamptz not null default now()
);

create or replace function crear_perfil()
returns trigger
language plpgsql
security definer
set search_path = public, extensions
as $$
declare
  datos jsonb := coalesce(new.raw_user_meta_data, '{}'::jsonb);
  tipo tipo_cuenta := coalesce(datos ->> 'tipo_cuenta', 'universitario')::tipo_cuenta;
begin
  insert into perfiles (id, universidad_id, nombre, correo, celular, tipo_cuenta, codigo_estudiantil, acepto_terminos)
  values (
    new.id,
    nullif(datos ->> 'universidad_id', '')::uuid,
    coalesce(nullif(datos ->> 'nombre', ''), 'Usuario FINDU'),
    case when tipo = 'universitario' then new.email end,
    nullif(datos ->> 'celular', ''),
    tipo,
    nullif(datos ->> 'codigo_estudiantil', ''),
    coalesce((datos ->> 'acepto_terminos')::boolean, false)
  );
  insert into ajustes_notificacion (perfil_id) values (new.id);
  return new;
end;
$$;

create trigger al_crear_usuario
after insert on auth.users
for each row execute function crear_perfil();

create or replace function normalizar(texto text)
returns text
language sql
immutable
as $$
  select regexp_replace(lower(trim(texto)), '\s+', ' ', 'g');
$$;

create or replace function es_participante(p_conversacion uuid)
returns boolean
language sql
stable
security definer
set search_path = public, extensions
as $$
  select exists (
    select 1 from conversaciones c
    where c.id = p_conversacion and auth.uid() in (c.dueno_id, c.contraparte_id)
  );
$$;

create or replace function puede_ver_publicacion(p_publicacion uuid)
returns boolean
language sql
stable
security definer
set search_path = public, extensions
as $$
  select exists (
    select 1 from publicaciones p
    where p.id = p_publicacion
      and (
        p.comunidad_id is null
        or p.autor_id = auth.uid()
        or exists (
          select 1 from miembros_comunidad m
          where m.comunidad_id = p.comunidad_id and m.perfil_id = auth.uid() and m.estado = 'aprobado'
        )
      )
  );
$$;

create or replace function es_admin(p_comunidad uuid)
returns boolean
language sql
stable
security definer
set search_path = public, extensions
as $$
  select exists (
    select 1 from miembros_comunidad m
    where m.comunidad_id = p_comunidad and m.perfil_id = auth.uid() and m.rol = 'admin' and m.estado = 'aprobado'
  );
$$;

create or replace function agregar_pregunta(p_publicacion uuid, p_texto text, p_respuesta text, p_orden int)
returns void
language plpgsql
security definer
set search_path = public, extensions
as $$
begin
  if not exists (select 1 from publicaciones where id = p_publicacion and autor_id = auth.uid()) then
    raise exception 'solo quien publica puede agregar preguntas';
  end if;
  insert into preguntas_verificacion (publicacion_id, texto, respuesta_hash, orden)
  values (p_publicacion, trim(p_texto), crypt(normalizar(p_respuesta), gen_salt('bf')), p_orden);
end;
$$;

create or replace function verificar_respuestas(p_publicacion uuid, p_respuestas text[])
returns jsonb
language plpgsql
security definer
set search_path = public, extensions
as $$
declare
  pub publicaciones;
  previos int;
  nuevo intentos_verificacion;
  pregunta record;
  correcta boolean;
  resultados boolean[] := '{}';
  aprobado boolean := true;
  conversacion uuid;
  i int := 0;
begin
  select * into pub from publicaciones where id = p_publicacion;
  if not found or pub.intencion <> 'encontrado' then
    raise exception 'publicacion no valida';
  end if;
  if pub.autor_id = auth.uid() then
    raise exception 'no puedes verificar tu propia publicacion';
  end if;

  select count(*) into previos from intentos_verificacion
  where publicacion_id = p_publicacion and solicitante_id = auth.uid();
  if previos >= 2 then
    raise exception 'sin_intentos';
  end if;

  insert into intentos_verificacion (publicacion_id, solicitante_id, numero)
  values (p_publicacion, auth.uid(), previos + 1)
  returning * into nuevo;

  for pregunta in
    select * from preguntas_verificacion where publicacion_id = p_publicacion order by orden
  loop
    i := i + 1;
    correcta := coalesce(crypt(normalizar(coalesce(p_respuestas[i], '')), pregunta.respuesta_hash) = pregunta.respuesta_hash, false);
    insert into respuestas (intento_id, pregunta_id, texto, es_correcta)
    values (nuevo.id, pregunta.id, coalesce(p_respuestas[i], ''), correcta);
    resultados := resultados || correcta;
    aprobado := aprobado and correcta;
  end loop;

  update intentos_verificacion
  set estado = case when aprobado then 'aprobado'::estado_intento else 'rechazado'::estado_intento end,
      resuelto_en = now()
  where id = nuevo.id;

  if aprobado then
    insert into conversaciones (publicacion_id, intento_id, dueno_id, contraparte_id)
    values (p_publicacion, nuevo.id, auth.uid(), pub.autor_id)
    returning id into conversacion;
    update publicaciones set estado = 'en_verificacion', actualizado_en = now() where id = p_publicacion;
    insert into notificaciones (perfil_id, publicacion_id, conversacion_id, tipo, titulo, cuerpo)
    values (pub.autor_id, p_publicacion, conversacion, 'verificacion', '¡Verificación aprobada!',
            'Alguien respondió bien tus preguntas de "' || pub.titulo || '". Ya pueden hablar por el chat.');
  end if;

  return jsonb_build_object(
    'aprobado', aprobado,
    'resultados', to_jsonb(resultados),
    'intentos_restantes', 2 - (previos + 1),
    'conversacion_id', conversacion
  );
end;
$$;

create or replace function reportar_hallazgo(p_publicacion uuid, p_donde donde_esta, p_estado estado_hallazgo, p_fotos text[])
returns uuid
language plpgsql
security definer
set search_path = public, extensions
as $$
declare
  pub publicaciones;
  reporte uuid;
  conversacion uuid;
  url text;
  n int := 0;
begin
  select * into pub from publicaciones where id = p_publicacion;
  if not found or pub.intencion <> 'perdido' then
    raise exception 'publicacion no valida';
  end if;
  if pub.autor_id = auth.uid() then
    raise exception 'no puedes reportar tu propia publicacion';
  end if;

  select c.id into conversacion from conversaciones c
  where c.publicacion_id = p_publicacion and c.contraparte_id = auth.uid() and c.estado = 'abierta'
  limit 1;
  if conversacion is not null then
    return conversacion;
  end if;

  insert into reportes_hallazgo (publicacion_id, reportado_por, donde_esta, estado_hallazgo)
  values (p_publicacion, auth.uid(), p_donde, p_estado)
  returning id into reporte;

  foreach url in array coalesce(p_fotos, '{}') loop
    n := n + 1;
    insert into fotos (reporte_id, url, tipo, orden)
    values (reporte, url, case when n = 1 then 'cara'::tipo_foto else 'cuerpo'::tipo_foto end, n);
  end loop;

  insert into conversaciones (publicacion_id, reporte_id, dueno_id, contraparte_id)
  values (p_publicacion, reporte, pub.autor_id, auth.uid())
  returning id into conversacion;

  insert into notificaciones (perfil_id, publicacion_id, conversacion_id, tipo, titulo, cuerpo)
  values (pub.autor_id, p_publicacion, conversacion, 'avistamiento', 'Alguien encontró ' || pub.titulo,
          'Te enviaron fotos. Revisa el chat para acordar la entrega.');

  return conversacion;
end;
$$;

create or replace function confirmar_entrega(p_conversacion uuid)
returns estado_entrega
language plpgsql
security definer
set search_path = public, extensions
as $$
declare
  conv conversaciones;
  ent entregas;
begin
  select * into conv from conversaciones where id = p_conversacion;
  if not found or auth.uid() not in (conv.dueno_id, conv.contraparte_id) then
    raise exception 'no participas en esta conversacion';
  end if;

  insert into entregas (conversacion_id, publicacion_id)
  values (conv.id, conv.publicacion_id)
  on conflict (conversacion_id) do nothing;

  update entregas
  set confirmo_dueno_en = case when auth.uid() = conv.dueno_id then now() else confirmo_dueno_en end,
      confirmo_contraparte_en = case when auth.uid() = conv.contraparte_id then now() else confirmo_contraparte_en end,
      estado = 'pendiente',
      motivo_problema = null,
      detalle_problema = null
  where conversacion_id = conv.id
  returning * into ent;

  if ent.confirmo_dueno_en is not null and ent.confirmo_contraparte_en is not null then
    update entregas set estado = 'confirmada' where id = ent.id returning * into ent;
    update publicaciones set estado = 'entregada', actualizado_en = now() where id = conv.publicacion_id;
    update conversaciones set estado = 'cerrada' where id = conv.id;
    update pagos set estado = 'liberado', entrega_id = ent.id, beneficiario_id = conv.contraparte_id
    where publicacion_id = conv.publicacion_id and concepto = 'recompensa' and estado = 'retenido';
  end if;

  return ent.estado;
end;
$$;

create or replace function reportar_problema(p_conversacion uuid, p_motivo motivo_problema, p_detalle text)
returns void
language plpgsql
security definer
set search_path = public, extensions
as $$
declare
  conv conversaciones;
begin
  select * into conv from conversaciones where id = p_conversacion;
  if not found or auth.uid() not in (conv.dueno_id, conv.contraparte_id) then
    raise exception 'no participas en esta conversacion';
  end if;

  insert into entregas (conversacion_id, publicacion_id, estado, motivo_problema, detalle_problema)
  values (conv.id, conv.publicacion_id, 'con_problema', p_motivo, nullif(trim(p_detalle), ''))
  on conflict (conversacion_id) do update
  set estado = 'con_problema',
      motivo_problema = excluded.motivo_problema,
      detalle_problema = excluded.detalle_problema,
      confirmo_dueno_en = null,
      confirmo_contraparte_en = null;

  update publicaciones set estado = 'activa', actualizado_en = now() where id = conv.publicacion_id;
end;
$$;

alter table universidades enable row level security;
alter table perfiles enable row level security;
alter table comunidades enable row level security;
alter table codigos_acceso enable row level security;
alter table miembros_comunidad enable row level security;
alter table lugares enable row level security;
alter table categorias enable row level security;
alter table publicaciones enable row level security;
alter table detalles_objeto enable row level security;
alter table detalles_mascota enable row level security;
alter table reportes_hallazgo enable row level security;
alter table fotos enable row level security;
alter table preguntas_verificacion enable row level security;
alter table intentos_verificacion enable row level security;
alter table respuestas enable row level security;
alter table conversaciones enable row level security;
alter table mensajes enable row level security;
alter table entregas enable row level security;
alter table planes_impulso enable row level security;
alter table metodos_pago enable row level security;
alter table pagos enable row level security;
alter table impulsos enable row level security;
alter table notificaciones enable row level security;
alter table ajustes_notificacion enable row level security;
alter table dispositivos enable row level security;

create policy "catalogo publico" on universidades for select using (true);
create policy "catalogo publico" on categorias for select using (true);
create policy "catalogo publico" on lugares for select using (true);
create policy "catalogo publico" on planes_impulso for select using (true);

create policy "ver perfiles" on perfiles for select to authenticated using (true);
create policy "editar mi perfil" on perfiles for update to authenticated using (id = auth.uid()) with check (id = auth.uid());

create policy "ver comunidades" on comunidades for select to authenticated using (true);
create policy "solicitar comunidad" on comunidades for insert to authenticated with check (creada_por = auth.uid());
create policy "ver mis membresias" on miembros_comunidad for select to authenticated
  using (perfil_id = auth.uid() or es_admin(comunidad_id));
create policy "solicitar ingreso" on miembros_comunidad for insert to authenticated
  with check (perfil_id = auth.uid() and estado = 'pendiente' and rol = 'miembro');
create policy "admin ve codigos" on codigos_acceso for select to authenticated
  using (es_admin(comunidad_id));

create policy "ver publicaciones" on publicaciones for select to authenticated using (puede_ver_publicacion(id));
create policy "publicar" on publicaciones for insert to authenticated with check (autor_id = auth.uid());
create policy "editar mi publicacion" on publicaciones for update to authenticated
  using (autor_id = auth.uid()) with check (autor_id = auth.uid());
create policy "borrar mi publicacion" on publicaciones for delete to authenticated using (autor_id = auth.uid());

create policy "ver detalle" on detalles_objeto for select to authenticated using (puede_ver_publicacion(publicacion_id));
create policy "crear detalle" on detalles_objeto for insert to authenticated
  with check (exists (select 1 from publicaciones p where p.id = publicacion_id and p.autor_id = auth.uid()));
create policy "ver detalle" on detalles_mascota for select to authenticated using (puede_ver_publicacion(publicacion_id));
create policy "crear detalle" on detalles_mascota for insert to authenticated
  with check (exists (select 1 from publicaciones p where p.id = publicacion_id and p.autor_id = auth.uid()));

create policy "ver fotos" on fotos for select to authenticated using (true);
create policy "subir fotos de mi publicacion" on fotos for insert to authenticated
  with check (exists (select 1 from publicaciones p where p.id = publicacion_id and p.autor_id = auth.uid()));

create policy "ver reportes" on reportes_hallazgo for select to authenticated
  using (reportado_por = auth.uid() or exists (
    select 1 from publicaciones p where p.id = publicacion_id and p.autor_id = auth.uid()
  ));

revoke select on preguntas_verificacion from anon, authenticated;
grant select (id, publicacion_id, texto, orden) on preguntas_verificacion to authenticated;
create policy "ver preguntas" on preguntas_verificacion for select to authenticated using (puede_ver_publicacion(publicacion_id));

create policy "ver mis intentos" on intentos_verificacion for select to authenticated
  using (solicitante_id = auth.uid() or exists (
    select 1 from publicaciones p where p.id = publicacion_id and p.autor_id = auth.uid()
  ));
create policy "ver respuestas" on respuestas for select to authenticated
  using (exists (
    select 1 from intentos_verificacion i
    join publicaciones p on p.id = i.publicacion_id
    where i.id = intento_id and auth.uid() in (i.solicitante_id, p.autor_id)
  ));

create policy "ver mis chats" on conversaciones for select to authenticated using (auth.uid() in (dueno_id, contraparte_id));
create policy "leer mensajes" on mensajes for select to authenticated using (es_participante(conversacion_id));
create policy "enviar mensajes" on mensajes for insert to authenticated
  with check (emisor_id = auth.uid() and es_participante(conversacion_id));
create policy "marcar leido" on mensajes for update to authenticated
  using (es_participante(conversacion_id) and emisor_id <> auth.uid());
create policy "ver entregas" on entregas for select to authenticated using (es_participante(conversacion_id));

create policy "mis metodos" on metodos_pago for all to authenticated using (perfil_id = auth.uid()) with check (perfil_id = auth.uid());
create policy "mis pagos" on pagos for select to authenticated using (auth.uid() in (perfil_id, beneficiario_id));
create policy "ver impulsos" on impulsos for select to authenticated
  using (exists (select 1 from publicaciones p where p.id = publicacion_id and p.autor_id = auth.uid()));
create policy "mis notificaciones" on notificaciones for select to authenticated using (perfil_id = auth.uid());
create policy "leer notificacion" on notificaciones for update to authenticated using (perfil_id = auth.uid());
create policy "mis ajustes" on ajustes_notificacion for all to authenticated using (perfil_id = auth.uid()) with check (perfil_id = auth.uid());
create policy "mis dispositivos" on dispositivos for all to authenticated using (perfil_id = auth.uid()) with check (perfil_id = auth.uid());

alter publication supabase_realtime add table mensajes;
alter publication supabase_realtime add table entregas;

insert into storage.buckets (id, name, public) values ('fotos', 'fotos', true) on conflict (id) do nothing;

create policy "subir mis fotos" on storage.objects for insert to authenticated
  with check (bucket_id = 'fotos' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "ver fotos" on storage.objects for select using (bucket_id = 'fotos');
create policy "reemplazar mis fotos" on storage.objects for update to authenticated
  using (bucket_id = 'fotos' and (storage.foldername(name))[1] = auth.uid()::text);

insert into universidades (nombre, dominio_correo) values
  ('Universidad Icesi', 'u.icesi.edu.co'),
  ('Pontificia Universidad Javeriana Cali', 'javerianacali.edu.co'),
  ('Universidad del Valle', 'correounivalle.edu.co'),
  ('Universidad Autónoma de Occidente', 'uao.edu.co'),
  ('Universidad de San Buenaventura Cali', 'correo.usbcali.edu.co');

insert into categorias (nombre, tipo) values
  ('Celular', 'objeto'), ('Mochila', 'objeto'), ('Billetera', 'objeto'), ('Llaves', 'objeto'),
  ('Audífonos', 'objeto'), ('Termo', 'objeto'), ('Cartuchera', 'objeto'), ('Parlante', 'objeto'),
  ('Otro', 'objeto'), ('Perro', 'mascota'), ('Gato', 'mascota'), ('Otro', 'mascota');

insert into lugares (nombre, tipo, latitud, longitud) values
  ('Biblioteca', 'campus', 3.341620, -76.530350),
  ('Cafetería', 'campus', 3.342050, -76.529800),
  ('Edificio A', 'campus', 3.341200, -76.530900),
  ('Edificio L', 'campus', 3.342500, -76.530600),
  ('Bienestar', 'campus', 3.340900, -76.529700),
  ('Coliseo', 'campus', 3.340500, -76.531200),
  ('Ciudad Jardín', 'barrio', 3.360500, -76.535000),
  ('Pance', 'barrio', 3.320000, -76.545000),
  ('Valle del Lili', 'barrio', 3.373000, -76.523000),
  ('El Ingenio', 'barrio', 3.387000, -76.524000),
  ('Cañas Gordas', 'barrio', 3.333000, -76.537000),
  ('Otro', 'barrio', 3.451600, -76.532000);

insert into planes_impulso (nombre, precio_cop, radio_km, alcance_personas, duracion_horas) values
  ('Básico', 5000, 3, 200, 24),
  ('Destacado', 8000, 8, 1200, 72);
