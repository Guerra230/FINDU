import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:findu/features/auth/domain/auth_models.dart';
import 'package:findu/features/auth/domain/auth_repository.dart';

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
  UniversitiesCubit(this._repository) : super(const UniversitiesState());

  final AuthRepository _repository;

  Future<void> load() async {
    emit(const UniversitiesState());
    try {
      emit(
        UniversitiesState(
          loading: false,
          items: await _repository.universities(),
        ),
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
