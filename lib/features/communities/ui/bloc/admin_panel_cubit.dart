import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:findu/features/communities/domain/communities_models.dart';
import 'package:findu/features/communities/domain/usecases/communities_usecases.dart';

enum AdminPanelStatus { loading, loaded, failure }

class AdminPanelState {
  const AdminPanelState({
    this.status = AdminPanelStatus.loading,
    this.panel,
    this.message,
  });

  final AdminPanelStatus status;
  final AdminPanel? panel;
  final String? message;
}

class AdminPanelCubit extends Cubit<AdminPanelState> {
  AdminPanelCubit({
    required ObtenerPanelAdmin obtenerPanel,
    required GenerarCodigo generarCodigo,
    required ResolverSolicitud resolverSolicitud,
    required this.communityId,
  }) : _obtenerPanel = obtenerPanel,
       _generarCodigo = generarCodigo,
       _resolverSolicitud = resolverSolicitud,
       super(const AdminPanelState());

  final ObtenerPanelAdmin _obtenerPanel;
  final GenerarCodigo _generarCodigo;
  final ResolverSolicitud _resolverSolicitud;
  final String communityId;

  Future<void> load() async {
    try {
      emit(
        AdminPanelState(
          status: AdminPanelStatus.loaded,
          panel: await _obtenerPanel(communityId),
        ),
      );
    } on CommunityFailure catch (e) {
      emit(
        AdminPanelState(status: AdminPanelStatus.failure, message: e.message),
      );
    } catch (_) {
      emit(
        const AdminPanelState(
          status: AdminPanelStatus.failure,
          message: 'No pudimos cargar el panel.',
        ),
      );
    }
  }

  Future<void> newCode() async {
    final panel = state.panel;
    if (panel == null) return;
    try {
      final code = await _generarCodigo(communityId);
      emit(
        AdminPanelState(
          status: AdminPanelStatus.loaded,
          panel: panel.copyWith(code: code, uses: 0),
        ),
      );
    } catch (_) {
      emit(
        AdminPanelState(
          status: AdminPanelStatus.loaded,
          panel: panel,
          message: 'No pudimos generar el código.',
        ),
      );
    }
  }

  Future<void> resolve(JoinRequest request, {required bool accept}) async {
    final panel = state.panel;
    if (panel == null) return;
    try {
      await _resolverSolicitud(request.id, accept: accept);
      emit(
        AdminPanelState(
          status: AdminPanelStatus.loaded,
          panel: panel.copyWith(
            requests: panel.requests.where((r) => r.id != request.id).toList(),
          ),
          message: accept
              ? '${request.name} ya es miembro'
              : 'Rechazaste la solicitud de ${request.name}',
        ),
      );
    } catch (_) {
      emit(
        AdminPanelState(
          status: AdminPanelStatus.loaded,
          panel: panel,
          message: 'No pudimos responder la solicitud.',
        ),
      );
    }
  }
}
