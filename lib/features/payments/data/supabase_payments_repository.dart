import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:findu/features/payments/domain/payments_models.dart';
import 'package:findu/features/payments/domain/payments_repository.dart';

class SupabasePaymentsRepository implements PaymentsRepository {
  SupabasePaymentsRepository(this._client);

  final SupabaseClient _client;

  String _provider(PaymentProvider provider) =>
      provider == PaymentProvider.card ? 'tarjeta' : 'nequi';

  @override
  Future<List<BoostPlan>> plans() async {
    final rows = await _client.from('planes_impulso').select();
    return rows.map(BoostPlan.fromRow).toList();
  }

  @override
  Future<List<PaymentMethod>> methods() async {
    final rows = await _client
        .from('metodos_pago')
        .select('id, proveedor, ultimos4, predeterminado');
    return rows.map(PaymentMethod.fromRow).toList();
  }

  @override
  Future<void> addMethod(PaymentProvider provider, String last4) async {
    await _client.rpc(
      'agregar_metodo_pago',
      params: {'p_proveedor': _provider(provider), 'p_ultimos4': last4},
    );
  }

  @override
  Future<void> setDefault(String methodId) async {
    final uid = _client.auth.currentUser!.id;
    await _client
        .from('metodos_pago')
        .update({'predeterminado': false})
        .eq('perfil_id', uid);
    await _client
        .from('metodos_pago')
        .update({'predeterminado': true})
        .eq('id', methodId);
  }

  @override
  Future<DateTime> boost({
    required String postId,
    required String planId,
    required PaymentProvider provider,
  }) async {
    try {
      final data = await _client.rpc(
        'impulsar_publicacion',
        params: {
          'p_publicacion': postId,
          'p_plan': planId,
          'p_proveedor': _provider(provider),
        },
      );
      return DateTime.parse(
        (data as Map<String, dynamic>)['termina_en'] as String,
      );
    } on PostgrestException catch (e) {
      if (e.message.contains('solo_el_autor')) {
        throw const PaymentFailure('Solo quien publicó puede impulsar');
      }
      throw const PaymentFailure(
        'No pudimos procesar el pago. Intenta de nuevo.',
      );
    }
  }
}
