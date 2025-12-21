import 'package:catdog/domain/model/follow_request_model.dart';
import 'package:catdog/domain/repository/follow_request_repository.dart';

class FollowRequestUseCase {
  FollowRequestUseCase(this._repository);
  final FollowRequestRepository _repository;

  Future<void> send(FollowRequestModel request) => _repository.sendRequest(request);
  Future<void> updateStatus(String id, String status) => _repository.updateRequestStatus(id, status);
  Future<List<FollowRequestModel>> getReceived(String userId) => _repository.getReceivedRequests(userId);
  Future<List<FollowRequestModel>> getSent(String userId) => _repository.getSentRequests(userId);
}
