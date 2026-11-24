import 'package:flutter_test/flutter_test.dart';

import 'package:findu/core/di/inyeccion.dart';
import 'package:findu/features/communities/communities_di.dart';
import 'package:findu/features/communities/domain/communities_models.dart';
import 'package:findu/features/communities/domain/communities_repository.dart';
import 'package:findu/features/communities/ui/bloc/admin_panel_cubit.dart';
import 'package:findu/features/communities/ui/bloc/communities_cubit.dart';
import 'package:findu/features/communities/ui/bloc/community_form_cubit.dart';

class FakeCommunitiesRepository implements CommunitiesRepository {
  final joined = <String>[];
  String? activated;

  @override
  Future<List<Community>> mine() async => const [
    Community(
      id: 'c1',
      name: 'Icesi',
      type: 'Educativa',
      members: 3,
      isAdmin: true,
      isActive: true,
      isPending: false,
    ),
    Community(
      id: 'c2',
      name: 'Bosques de Lili',
      type: 'Residencial',
      members: 10,
      isAdmin: false,
      isActive: false,
      isPending: false,
    ),
  ];

  @override
  Future<String> create(NewCommunity community) async => 'nueva';

  @override
  Future<String> joinWithCode(String code) async {
    if (code != 'LILI-4821') {
      throw const CommunityFailure(
        'Código inválido o vencido. Pídeselo al admin.',
      );
    }
    joined.add(code);
    return 'Bosques de Lili';
  }

  @override
  Future<String> requestToJoin(String communityName) async => communityName;

  @override
  Future<void> activate(String communityId) async => activated = communityId;

  @override
  Future<AdminPanel> adminPanel(String communityId) async => AdminPanel(
    code: 'ICES-1234',
    uses: 2,
    maxUses: 20,
    requests: [
      JoinRequest(id: 'r1', name: 'Ana', requestedAt: DateTime(2026, 11, 24)),
    ],
  );

  @override
  Future<String> newCode(String communityId) async => 'ICES-9999';

  @override
  Future<void> resolveRequest(String requestId, {required bool accept}) async {}
}

void main() {
  late FakeCommunitiesRepository repository;

  setUp(() async {
    await sl.reset();
    repository = FakeCommunitiesRepository();
    sl.registerLazySingleton<CommunitiesRepository>(() => repository);
    registrarComunidades(sl);
  });

  test(
    'CommunitiesCubit carga y separa las comunidades donde soy admin',
    () async {
      final cubit = sl<CommunitiesCubit>();
      await cubit.load();

      expect(cubit.state.items, hasLength(2));
      expect(cubit.state.adminOf.map((c) => c.name), ['Icesi']);
      await cubit.close();
    },
  );

  test('cambiar la comunidad activa llama al repositorio', () async {
    final cubit = sl<CommunitiesCubit>();
    await cubit.load();
    await cubit.activate(cubit.state.items.last);

    expect(repository.activated, 'c2');
    await cubit.close();
  });

  test(
    'unirse con un código con formato inválido no llama al repositorio',
    () async {
      final cubit = sl<JoinCommunityCubit>();
      await cubit.joinWithCode('abc');

      expect(cubit.state.status, CommunityFormStatus.failure);
      expect(repository.joined, isEmpty);
      await cubit.close();
    },
  );

  test('unirse con un código válido', () async {
    final cubit = sl<JoinCommunityCubit>();
    await cubit.joinWithCode('lili-4821');

    expect(cubit.state.status, CommunityFormStatus.joined);
    expect(cubit.state.communityName, 'Bosques de Lili');
    await cubit.close();
  });

  test('el panel del admin genera código y responde solicitudes', () async {
    final cubit = sl<AdminPanelCubit>(param1: 'c1');
    await cubit.load();
    expect(cubit.state.panel!.requests, hasLength(1));

    await cubit.newCode();
    expect(cubit.state.panel!.code, 'ICES-9999');

    await cubit.resolve(cubit.state.panel!.requests.first, accept: true);
    expect(cubit.state.panel!.requests, isEmpty);
    expect(cubit.state.message, 'Ana ya es miembro');
    await cubit.close();
  });
}
