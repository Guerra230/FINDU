import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:findu/features/communities/domain/communities_models.dart';
import 'package:findu/features/communities/domain/usecases/communities_usecases.dart';

enum CommunityFormStatus {
  editing,
  sending,
  joined,
  requested,
  created,
  failure,
}

class CommunityFormState {
  const CommunityFormState({
    this.status = CommunityFormStatus.editing,
    this.communityName,
    this.error,
  });

  final CommunityFormStatus status;
  final String? communityName;
  final String? error;

  bool get isSending => status == CommunityFormStatus.sending;
}

class JoinCommunityCubit extends Cubit<CommunityFormState> {
  JoinCommunityCubit({
    required UnirseConCodigo unirseConCodigo,
    required SolicitarIngreso solicitarIngreso,
  }) : _unirseConCodigo = unirseConCodigo,
       _solicitarIngreso = solicitarIngreso,
       super(const CommunityFormState());

  final UnirseConCodigo _unirseConCodigo;
  final SolicitarIngreso _solicitarIngreso;

  Future<void> joinWithCode(String code) => _run(() async {
    final name = await _unirseConCodigo(code);
    emit(
      CommunityFormState(
        status: CommunityFormStatus.joined,
        communityName: name,
      ),
    );
  });

  Future<void> requestToJoin(String communityName) => _run(() async {
    final name = await _solicitarIngreso(communityName);
    emit(
      CommunityFormState(
        status: CommunityFormStatus.requested,
        communityName: name,
      ),
    );
  });

  void clearError() {
    if (state.error != null) emit(const CommunityFormState());
  }

  Future<void> _run(Future<void> Function() action) async {
    emit(const CommunityFormState(status: CommunityFormStatus.sending));
    try {
      await action();
    } on CommunityFailure catch (e) {
      emit(
        CommunityFormState(
          status: CommunityFormStatus.failure,
          error: e.message,
        ),
      );
    } catch (_) {
      emit(
        const CommunityFormState(
          status: CommunityFormStatus.failure,
          error: 'Revisa tu conexión e intenta de nuevo.',
        ),
      );
    }
  }
}

class CreateCommunityCubit extends Cubit<CommunityFormState> {
  CreateCommunityCubit(this._crearComunidad)
    : super(const CommunityFormState());

  final CrearComunidad _crearComunidad;

  Future<void> create(NewCommunity community) async {
    emit(const CommunityFormState(status: CommunityFormStatus.sending));
    try {
      await _crearComunidad(community);
      emit(
        CommunityFormState(
          status: CommunityFormStatus.created,
          communityName: community.name.trim(),
        ),
      );
    } on CommunityFailure catch (e) {
      emit(
        CommunityFormState(
          status: CommunityFormStatus.failure,
          error: e.message,
        ),
      );
    } catch (_) {
      emit(
        const CommunityFormState(
          status: CommunityFormStatus.failure,
          error: 'Revisa tu conexión e intenta de nuevo.',
        ),
      );
    }
  }
}
