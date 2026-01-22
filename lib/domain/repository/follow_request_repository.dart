import 'dart:async';

import 'package:catdog/domain/model/follow_request_model.dart';

abstract interface class FollowRequestRepository {
  Future<String> sendFollowRequest(String friendId);
  Future<bool> updateFollowRequest(String friendId, String type);
  Future<List<FollowRequestModel>> getAllFollowRequest();
  Future<bool> rejectFollowRequest(String friendId);
  Future<bool> acceptFollowRequest(String friendId);
  Future<bool> deleteFollowRequest(String friendId);
  Future<List<FollowRequestModel>> getMyRequests();
  Future<bool> checkFollowPending(String freindId);
  Future<bool> checkRequestPending(String friendId);
}
