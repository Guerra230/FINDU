create or replace function generar_codigo(p_nombre text)
returns text
language sql
volatile
as $$
  select upper(substr(regexp_replace(coalesce(p_nombre, 'FIND'), '[^a-zA-Z]', '', 'g') || 'FIND', 1, 4))
    || '-' || lpad((floor(random() * 9000) + 1000)::int::text, 4, '0');
$$;

create or replace function crear_comunidad(p_nombre text, p_tipo tipo_comunidad, p_direccion text)
returns uuid
language plpgsql
security definer
set search_path = public, extensions
as $$
declare
  comunidad uuid;
  tiene_activa boolean;
begin
  if coalesce(trim(p_nombre), '') = '' then
    raise exception 'nombre_vacio';
  end if;

  insert into comunidades (creada_por, nombre, tipo, direccion, estado, revisada_en)
  values (auth.uid(), trim(p_nombre), p_tipo, nullif(trim(p_direccion), ''), 'activa', now())
  returning id into comunidad;

  select exists (select 1 from miembros_comunidad where perfil_id = auth.uid() and es_activa) into tiene_activa;

  insert into miembros_comunidad (comunidad_id, perfil_id, rol, metodo_ingreso, estado, es_activa, unido_en)
  values (comunidad, auth.uid(), 'admin', 'creador', 'aprobado', not tiene_activa, now());

  insert into codigos_acceso (comunidad_id, creado_por, codigo, vence_en)
  values (comunidad, auth.uid(), generar_codigo(p_nombre), now() + interval '30 days');

  return comunidad;
end;
$$;

create or replace function unirse_con_codigo(p_codigo text)
returns text
language plpgsql
security definer
set search_path = public, extensions
as $$
declare
  cod codigos_acceso;
  nombre_comunidad text;
  tiene_activa boolean;
begin
  select * into cod from codigos_acceso
  where codigo = upper(trim(p_codigo)) and activo and vence_en > now() and usos_actuales < usos_maximos;
  if not found then
    raise exception 'codigo_invalido';
  end if;

  if exists (select 1 from miembros_comunidad where comunidad_id = cod.comunidad_id and perfil_id = auth.uid() and estado = 'aprobado') then
    raise exception 'ya_miembro';
  end if;

  select exists (select 1 from miembros_comunidad where perfil_id = auth.uid() and es_activa) into tiene_activa;

  insert into miembros_comunidad (comunidad_id, perfil_id, metodo_ingreso, codigo_id, estado, es_activa, unido_en)
  values (cod.comunidad_id, auth.uid(), 'codigo', cod.id, 'aprobado', not tiene_activa, now())
  on conflict (comunidad_id, perfil_id) do update
  set estado = 'aprobado', metodo_ingreso = 'codigo', codigo_id = excluded.codigo_id, unido_en = now();

  update codigos_acceso set usos_actuales = usos_actuales + 1 where id = cod.id;

  select nombre into nombre_comunidad from comunidades where id = cod.comunidad_id;
  return nombre_comunidad;
end;
$$;

create or replace function solicitar_ingreso(p_nombre text)
returns text
language plpgsql
security definer
set search_path = public, extensions
as $$
declare
  com comunidades;
begin
  select * into com from comunidades
  where lower(nombre) = lower(trim(p_nombre)) and estado = 'activa'
  limit 1;
  if not found then
    raise exception 'comunidad_no_existe';
  end if;

  if exists (select 1 from miembros_comunidad where comunidad_id = com.id and perfil_id = auth.uid() and estado = 'aprobado') then
    raise exception 'ya_miembro';
  end if;

  insert into miembros_comunidad (comunidad_id, perfil_id, metodo_ingreso, estado)
  values (com.id, auth.uid(), 'aprobacion', 'pendiente')
  on conflict (comunidad_id, perfil_id) do update
  set estado = 'pendiente', metodo_ingreso = 'aprobacion', solicitado_en = now();

  insert into notificaciones (perfil_id, tipo, titulo, cuerpo)
  select m.perfil_id, 'comunidad', 'Nueva solicitud en ' || com.nombre,
         (select nombre from perfiles where id = auth.uid()) || ' quiere unirse.'
  from miembros_comunidad m
  where m.comunidad_id = com.id and m.rol = 'admin' and m.estado = 'aprobado';

  return com.nombre;
end;
$$;

create or replace function mis_comunidades()
returns table (
  id uuid,
  nombre text,
  tipo tipo_comunidad,
  estado estado_membresia,
  rol rol_miembro,
  es_activa boolean,
  miembros bigint
)
language sql
stable
security definer
set search_path = public, extensions
as $$
  select c.id, c.nombre, c.tipo, m.estado, m.rol, m.es_activa,
         (select count(*) from miembros_comunidad x where x.comunidad_id = c.id and x.estado = 'aprobado')
  from miembros_comunidad m
  join comunidades c on c.id = m.comunidad_id
  where m.perfil_id = auth.uid() and m.estado <> 'rechazado'
  order by m.es_activa desc, c.nombre;
$$;

create or replace function activar_comunidad(p_comunidad uuid)
returns void
language plpgsql
security definer
set search_path = public, extensions
as $$
begin
  if not exists (select 1 from miembros_comunidad where comunidad_id = p_comunidad and perfil_id = auth.uid() and estado = 'aprobado') then
    raise exception 'no_eres_miembro';
  end if;
  update miembros_comunidad set es_activa = false where perfil_id = auth.uid() and es_activa;
  update miembros_comunidad set es_activa = true where perfil_id = auth.uid() and comunidad_id = p_comunidad;
end;
$$;

create or replace function panel_admin(p_comunidad uuid)
returns jsonb
language plpgsql
stable
security definer
set search_path = public, extensions
as $$
declare
  cod codigos_acceso;
begin
  if not es_admin(p_comunidad) then
    raise exception 'no_eres_admin';
  end if;

  select * into cod from codigos_acceso
  where comunidad_id = p_comunidad and activo
  order by vence_en desc
  limit 1;

  return jsonb_build_object(
    'codigo', cod.codigo,
    'usos', coalesce(cod.usos_actuales, 0),
    'usos_maximos', coalesce(cod.usos_maximos, 20),
    'vence_en', cod.vence_en,
    'solicitudes', coalesce((
      select jsonb_agg(jsonb_build_object('id', m.id, 'nombre', p.nombre, 'solicitado_en', m.solicitado_en) order by m.solicitado_en)
      from miembros_comunidad m
      join perfiles p on p.id = m.perfil_id
      where m.comunidad_id = p_comunidad and m.estado = 'pendiente'
    ), '[]'::jsonb)
  );
end;
$$;

create or replace function nuevo_codigo(p_comunidad uuid)
returns text
language plpgsql
security definer
set search_path = public, extensions
as $$
declare
  nuevo text;
begin
  if not es_admin(p_comunidad) then
    raise exception 'no_eres_admin';
  end if;
  update codigos_acceso set activo = false where comunidad_id = p_comunidad and activo;
  insert into codigos_acceso (comunidad_id, creado_por, codigo, vence_en)
  values (p_comunidad, auth.uid(), generar_codigo((select nombre from comunidades where id = p_comunidad)), now() + interval '30 days')
  returning codigo into nuevo;
  return nuevo;
end;
$$;

create or replace function resolver_solicitud(p_miembro uuid, p_aceptar boolean)
returns void
language plpgsql
security definer
set search_path = public, extensions
as $$
declare
  mem miembros_comunidad;
  nombre_comunidad text;
begin
  select * into mem from miembros_comunidad where id = p_miembro;
  if not found or not es_admin(mem.comunidad_id) then
    raise exception 'no_eres_admin';
  end if;

  update miembros_comunidad
  set estado = case when p_aceptar then 'aprobado'::estado_membresia else 'rechazado'::estado_membresia end,
      aprobado_por = auth.uid(),
      unido_en = case when p_aceptar then now() else null end,
      es_activa = p_aceptar and not exists (
        select 1 from miembros_comunidad x where x.perfil_id = mem.perfil_id and x.es_activa
      )
  where id = p_miembro;

  select nombre into nombre_comunidad from comunidades where id = mem.comunidad_id;
  insert into notificaciones (perfil_id, tipo, titulo, cuerpo)
  values (
    mem.perfil_id,
    'comunidad',
    case when p_aceptar then '¡Ya eres parte de ' || nombre_comunidad || '!' else 'Solicitud no aceptada' end,
    case when p_aceptar then 'El administrador aceptó tu solicitud.' else 'El administrador de ' || nombre_comunidad || ' rechazó tu solicitud.' end
  );
end;
$$;

create or replace function impulsar_publicacion(p_publicacion uuid, p_plan uuid, p_proveedor proveedor_pago)
returns jsonb
language plpgsql
security definer
set search_path = public, extensions
as $$
declare
  pub publicaciones;
  plan_elegido planes_impulso;
  metodo uuid;
  pago uuid;
  fin timestamptz;
begin
  select * into pub from publicaciones where id = p_publicacion;
  if not found or pub.autor_id <> auth.uid() then
    raise exception 'solo_el_autor';
  end if;
  select * into plan_elegido from planes_impulso where id = p_plan;
  if not found then
    raise exception 'plan_no_existe';
  end if;

  select id into metodo from metodos_pago
  where perfil_id = auth.uid() and proveedor = p_proveedor
  order by predeterminado desc
  limit 1;
  if metodo is null then
    insert into metodos_pago (perfil_id, proveedor, token_pasarela, ultimos4, predeterminado)
    values (auth.uid(), p_proveedor, 'SIM-' || extract(epoch from now())::bigint, '0000', true)
    returning id into metodo;
  end if;

  insert into pagos (perfil_id, metodo_pago_id, publicacion_id, concepto, monto_cop, estado)
  values (auth.uid(), metodo, p_publicacion, 'impulso', plan_elegido.precio_cop, 'liberado')
  returning id into pago;

  fin := now() + make_interval(hours => plan_elegido.duracion_horas);
  insert into impulsos (publicacion_id, plan_id, pago_id, inicia_en, termina_en)
  values (p_publicacion, p_plan, pago, now(), fin);

  insert into notificaciones (perfil_id, publicacion_id, tipo, titulo, cuerpo)
  values (auth.uid(), p_publicacion, 'impulso', 'Impulso activo',
          pub.titulo || ' llega a ' || plan_elegido.radio_km || ' km durante ' || plan_elegido.duracion_horas || ' horas.');

  return jsonb_build_object('termina_en', fin, 'pago_id', pago);
end;
$$;

create or replace function agregar_metodo_pago(p_proveedor proveedor_pago, p_ultimos4 text)
returns uuid
language plpgsql
security definer
set search_path = public, extensions
as $$
declare
  metodo uuid;
begin
  if p_ultimos4 !~ '^[0-9]{4}$' then
    raise exception 'ultimos4_invalidos';
  end if;
  update metodos_pago set predeterminado = false where perfil_id = auth.uid();
  insert into metodos_pago (perfil_id, proveedor, token_pasarela, ultimos4, predeterminado)
  values (auth.uid(), p_proveedor, 'SIM-' || extract(epoch from now())::bigint, p_ultimos4, true)
  returning id into metodo;
  return metodo;
end;
$$;
