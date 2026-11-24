import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:findu/features/payments/domain/payments_models.dart';
import 'package:findu/features/payments/domain/usecases/payments_usecases.dart';

enum PaymentMethodsStatus { loading, loaded, failure }

class PaymentMethodsState {
  const PaymentMethodsState({
    this.status = PaymentMethodsStatus.loading,
    this.items = const [],
    this.message,
  });

  final PaymentMethodsStatus status;
  final List<PaymentMethod> items;
  final String? message;
}

class PaymentMethodsCubit extends Cubit<PaymentMethodsState> {
  PaymentMethodsCubit({
    required ObtenerMetodosPago obtenerMetodos,
    required AgregarMetodoPago agregarMetodo,
    required ElegirMetodoPredeterminado elegirPredeterminado,
  }) : _obtenerMetodos = obtenerMetodos,
       _agregarMetodo = agregarMetodo,
       _elegirPredeterminado = elegirPredeterminado,
       super(const PaymentMethodsState());

  final ObtenerMetodosPago _obtenerMetodos;
  final AgregarMetodoPago _agregarMetodo;
  final ElegirMetodoPredeterminado _elegirPredeterminado;

  Future<void> load() async {
    try {
      emit(
        PaymentMethodsState(
          status: PaymentMethodsStatus.loaded,
          items: await _obtenerMetodos(),
        ),
      );
    } catch (_) {
      emit(
        PaymentMethodsState(
          status: PaymentMethodsStatus.failure,
          items: state.items,
          message: 'No pudimos cargar tus métodos de pago.',
        ),
      );
    }
  }

  Future<bool> add(PaymentProvider provider, String last4) async {
    try {
      await _agregarMetodo(provider, last4);
      await load();
      return true;
    } on PaymentFailure catch (e) {
      emit(
        PaymentMethodsState(
          status: PaymentMethodsStatus.loaded,
          items: state.items,
          message: e.message,
        ),
      );
      return false;
    } catch (_) {
      emit(
        PaymentMethodsState(
          status: PaymentMethodsStatus.loaded,
          items: state.items,
          message: 'No pudimos guardar el método.',
        ),
      );
      return false;
    }
  }

  Future<void> makeDefault(PaymentMethod method) async {
    try {
      await _elegirPredeterminado(method);
      await load();
    } catch (_) {
      emit(
        PaymentMethodsState(
          status: PaymentMethodsStatus.loaded,
          items: state.items,
          message: 'No pudimos cambiar el método predeterminado.',
        ),
      );
    }
  }
}
