import 'package:catdog/domain/model/follow_request_model.dart';

abstract interface class FollowRequestRepository {
  Future<bool> sendFollowRequest(String friendId);
  Future<bool> updateFollowRequest(String friendId, String type);
  Future<List<FollowRequestModel>> getAllFollowRequest();
  Future<bool> rejectFollowRequest(String friendId);
  Future<bool> acceptFollowRequest(String friendId);
}
