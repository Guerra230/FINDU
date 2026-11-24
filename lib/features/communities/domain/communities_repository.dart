import 'package:findu/features/communities/domain/communities_models.dart';

abstract interface class CommunitiesRepository {
  Future<List<Community>> mine();

  Future<String> create(NewCommunity community);

  Future<String> joinWithCode(String code);

  Future<String> requestToJoin(String communityName);

  Future<void> activate(String communityId);

  Future<AdminPanel> adminPanel(String communityId);

  Future<String> newCode(String communityId);

  Future<void> resolveRequest(String requestId, {required bool accept});
}
