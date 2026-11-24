import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:findu/features/auth/domain/auth_models.dart';
import 'package:findu/features/auth/domain/usecases/auth_usecases.dart';

class UniversitiesState {
  const UniversitiesState({
    this.loading = true,
    this.items = const [],
    this.error,
  });

  final bool loading;
  final List<University> items;
  final String? error;
}

class UniversitiesCubit extends Cubit<UniversitiesState> {
  UniversitiesCubit(this._obtenerUniversidades)
    : super(const UniversitiesState());

  final ObtenerUniversidades _obtenerUniversidades;

  Future<void> load() async {
    emit(const UniversitiesState());
    try {
      emit(
        UniversitiesState(loading: false, items: await _obtenerUniversidades()),
      );
    } catch (_) {
      emit(
        const UniversitiesState(
          loading: false,
          error: 'No pudimos cargar las universidades.',
        ),
      );
    }
  }
}
