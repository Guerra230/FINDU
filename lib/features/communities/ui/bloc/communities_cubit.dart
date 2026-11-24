import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:findu/features/communities/domain/communities_models.dart';
import 'package:findu/features/communities/domain/usecases/communities_usecases.dart';

enum CommunitiesStatus { loading, loaded, failure }

class CommunitiesState {
  const CommunitiesState({
    this.status = CommunitiesStatus.loading,
    this.items = const [],
    this.error,
  });

  final CommunitiesStatus status;
  final List<Community> items;
  final String? error;

  List<Community> get adminOf =>
      items.where((c) => c.isAdmin && !c.isPending).toList();
}

class CommunitiesCubit extends Cubit<CommunitiesState> {
  CommunitiesCubit({
    required ObtenerMisComunidades obtenerMisComunidades,
    required ActivarComunidad activarComunidad,
  }) : _obtenerMisComunidades = obtenerMisComunidades,
       _activarComunidad = activarComunidad,
       super(const CommunitiesState());

  final ObtenerMisComunidades _obtenerMisComunidades;
  final ActivarComunidad _activarComunidad;

  Future<void> load() async {
    try {
      emit(
        CommunitiesState(
          status: CommunitiesStatus.loaded,
          items: await _obtenerMisComunidades(),
        ),
      );
    } catch (_) {
      emit(
        CommunitiesState(
          status: CommunitiesStatus.failure,
          items: state.items,
          error: 'No pudimos cargar tus comunidades.',
        ),
      );
    }
  }

  Future<void> activate(Community community) async {
    if (community.isActive || community.isPending) return;
    try {
      await _activarComunidad(community.id);
      await load();
    } on CommunityFailure catch (e) {
      emit(
        CommunitiesState(
          status: CommunitiesStatus.loaded,
          items: state.items,
          error: e.message,
        ),
      );
    } catch (_) {
      emit(
        CommunitiesState(
          status: CommunitiesStatus.loaded,
          items: state.items,
          error: 'No pudimos cambiar la comunidad activa.',
        ),
      );
    }
  }
}
