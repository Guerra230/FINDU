import 'package:findu/features/communities/domain/communities_models.dart';
import 'package:findu/features/communities/domain/communities_repository.dart';

class ObtenerMisComunidades {
  const ObtenerMisComunidades(this._repository);

  final CommunitiesRepository _repository;

  Future<List<Community>> call() => _repository.mine();
}

class CrearComunidad {
  const CrearComunidad(this._repository);

  final CommunitiesRepository _repository;

  Future<String> call(NewCommunity community) {
    if (community.name.trim().length < 3) {
      throw const CommunityFailure('El nombre debe tener mínimo 3 letras');
    }
    if (!communityTypes.containsKey(community.type)) {
      throw const CommunityFailure('Elige el tipo de comunidad');
    }
    if (community.address.trim().isEmpty) {
      throw const CommunityFailure('Escribe la ubicación');
    }
    return _repository.create(community);
  }
}

class UnirseConCodigo {
  const UnirseConCodigo(this._repository);

  final CommunitiesRepository _repository;

  Future<String> call(String code) {
    final value = code.trim().toUpperCase();
    if (!RegExp(r'^[A-Z]{4}-\d{4}$').hasMatch(value)) {
      throw const CommunityFailure('El código tiene la forma LILI-4821');
    }
    return _repository.joinWithCode(value);
  }
}

class SolicitarIngreso {
  const SolicitarIngreso(this._repository);

  final CommunitiesRepository _repository;

  Future<String> call(String communityName) {
    if (communityName.trim().isEmpty) {
      throw const CommunityFailure('Escribe el nombre de la comunidad');
    }
    return _repository.requestToJoin(communityName.trim());
  }
}

class ActivarComunidad {
  const ActivarComunidad(this._repository);

  final CommunitiesRepository _repository;

  Future<void> call(String communityId) => _repository.activate(communityId);
}

class ObtenerPanelAdmin {
  const ObtenerPanelAdmin(this._repository);

  final CommunitiesRepository _repository;

  Future<AdminPanel> call(String communityId) =>
      _repository.adminPanel(communityId);
}

class GenerarCodigo {
  const GenerarCodigo(this._repository);

  final CommunitiesRepository _repository;

  Future<String> call(String communityId) => _repository.newCode(communityId);
}

class ResolverSolicitud {
  const ResolverSolicitud(this._repository);

  final CommunitiesRepository _repository;

  Future<void> call(String requestId, {required bool accept}) =>
      _repository.resolveRequest(requestId, accept: accept);
}
