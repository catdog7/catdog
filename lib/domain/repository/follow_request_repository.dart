import 'package:catdog/domain/model/follow_request_model.dart';

abstract interface class FollowRequestRepository {
  Future<void> addFollowRequest(FollowRequestModel followRequest);
  Future<void> updateFollowRequest(FollowRequestModel followRequest);
  Future<List<FollowRequestModel>> getAllFollowRequest(String userId);
  Future<void> deleteFollowRequest(String userAID, String userBID);
}
