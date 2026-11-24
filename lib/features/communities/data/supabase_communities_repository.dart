import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:findu/features/communities/domain/communities_models.dart';
import 'package:findu/features/communities/domain/communities_repository.dart';

class SupabaseCommunitiesRepository implements CommunitiesRepository {
  SupabaseCommunitiesRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<List<Community>> mine() => _guard(() async {
    final rows = await _client.rpc('mis_comunidades') as List;
    return [for (final r in rows) Community.fromRow(r as Map<String, dynamic>)];
  });

  @override
  Future<String> create(NewCommunity community) => _guard(() async {
    final id = await _client.rpc(
      'crear_comunidad',
      params: {
        'p_nombre': community.name.trim(),
        'p_tipo': communityTypes[community.type],
        'p_direccion': community.address.trim(),
      },
    );
    return id as String;
  });

  @override
  Future<String> joinWithCode(String code) => _guard(() async {
    final name = await _client.rpc(
      'unirse_con_codigo',
      params: {'p_codigo': code},
    );
    return name as String;
  });

  @override
  Future<String> requestToJoin(String communityName) => _guard(() async {
    final name = await _client.rpc(
      'solicitar_ingreso',
      params: {'p_nombre': communityName},
    );
    return name as String;
  });

  @override
  Future<void> activate(String communityId) => _guard(() async {
    await _client.rpc(
      'activar_comunidad',
      params: {'p_comunidad': communityId},
    );
  });

  @override
  Future<AdminPanel> adminPanel(String communityId) => _guard(() async {
    final data = await _client.rpc(
      'panel_admin',
      params: {'p_comunidad': communityId},
    );
    return AdminPanel.fromJson(data as Map<String, dynamic>);
  });

  @override
  Future<String> newCode(String communityId) => _guard(() async {
    final code = await _client.rpc(
      'nuevo_codigo',
      params: {'p_comunidad': communityId},
    );
    return code as String;
  });

  @override
  Future<void> resolveRequest(String requestId, {required bool accept}) =>
      _guard(() async {
        await _client.rpc(
          'resolver_solicitud',
          params: {'p_miembro': requestId, 'p_aceptar': accept},
        );
      });

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on PostgrestException catch (e) {
      throw CommunityFailure(_message(e.message));
    }
  }

  String _message(String text) {
    if (text.contains('codigo_invalido')) {
      return 'Código inválido o vencido. Pídeselo al admin.';
    }
    if (text.contains('ya_miembro')) return 'Ya eres miembro de esa comunidad';
    if (text.contains('comunidad_no_existe')) {
      return 'No encontramos una comunidad con ese nombre';
    }
    if (text.contains('no_eres_admin')) {
      return 'Solo el administrador puede hacer esto';
    }
    if (text.contains('duplicate')) {
      return 'Ya existe una comunidad con esos datos';
    }
    return 'No pudimos completar la operación. Intenta de nuevo.';
  }
}
