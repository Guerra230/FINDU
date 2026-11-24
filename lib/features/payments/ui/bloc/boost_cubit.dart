import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:findu/features/payments/domain/payments_models.dart';
import 'package:findu/features/payments/domain/usecases/payments_usecases.dart';

enum BoostStatus { loading, ready, paying, done, failure }

class BoostState {
  const BoostState({
    this.status = BoostStatus.loading,
    this.plans = const [],
    this.method,
    this.selected = 0,
    this.result,
    this.error,
  });

  final BoostStatus status;
  final List<BoostPlan> plans;
  final PaymentMethod? method;
  final int selected;
  final BoostResult? result;
  final String? error;

  BoostPlan? get plan =>
      plans.isEmpty ? null : plans[selected.clamp(0, plans.length - 1)];

  BoostState copyWith({
    BoostStatus? status,
    List<BoostPlan>? plans,
    PaymentMethod? method,
    int? selected,
    BoostResult? result,
    String? error,
  }) => BoostState(
    status: status ?? this.status,
    plans: plans ?? this.plans,
    method: method ?? this.method,
    selected: selected ?? this.selected,
    result: result ?? this.result,
    error: error,
  );
}

class BoostCubit extends Cubit<BoostState> {
  BoostCubit({
    required ObtenerPlanesImpulso obtenerPlanes,
    required ObtenerMetodosPago obtenerMetodos,
    required ImpulsarPublicacion impulsar,
    required this.postId,
  }) : _obtenerPlanes = obtenerPlanes,
       _obtenerMetodos = obtenerMetodos,
       _impulsar = impulsar,
       super(const BoostState());

  final ObtenerPlanesImpulso _obtenerPlanes;
  final ObtenerMetodosPago _obtenerMetodos;
  final ImpulsarPublicacion _impulsar;
  final String postId;

  Future<void> load() async {
    try {
      final plans = await _obtenerPlanes();
      final methods = await _obtenerMetodos();
      emit(
        BoostState(
          status: BoostStatus.ready,
          plans: plans,
          method: methods.isEmpty ? null : methods.first,
          selected: plans.length > 1 ? 1 : 0,
        ),
      );
    } catch (_) {
      emit(
        const BoostState(
          status: BoostStatus.failure,
          error: 'No pudimos cargar los planes.',
        ),
      );
    }
  }

  void select(int index) => emit(state.copyWith(selected: index));

  Future<void> pay() async {
    final plan = state.plan;
    if (plan == null) return;
    emit(state.copyWith(status: BoostStatus.paying));
    try {
      final result = await _impulsar(
        postId: postId,
        plan: plan,
        method: state.method,
      );
      emit(state.copyWith(status: BoostStatus.done, result: result));
    } on PaymentFailure catch (e) {
      emit(state.copyWith(status: BoostStatus.ready, error: e.message));
    } catch (_) {
      emit(
        state.copyWith(
          status: BoostStatus.ready,
          error: 'No pudimos procesar el pago.',
        ),
      );
    }
  }
}
