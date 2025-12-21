import 'package:catdog/domain/model/follow_request_model.dart';

abstract interface class FollowRequestRepository {
  Future<void> sendRequest(FollowRequestModel request);
  Future<void> updateRequestStatus(String id, String status);
  Future<List<FollowRequestModel>> getReceivedRequests(String userId);
  Future<List<FollowRequestModel>> getSentRequests(String userId);
}
