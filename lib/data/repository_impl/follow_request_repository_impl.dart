import 'package:catdog/data/dto/follow_request_dto.dart';
import 'package:catdog/data/mapper/follow_request_mapper.dart';
import 'package:catdog/domain/model/follow_request_model.dart';
import 'package:catdog/domain/repository/follow_request_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FollowRequestRepositoryImpl implements FollowRequestRepository {
  FollowRequestRepositoryImpl({required this.client});
  final SupabaseClient client;

  @override
  Future<void> sendRequest(FollowRequestModel request) async {
    final dto = FollowRequestMapper.toDto(request);
    await client.from('follow_requests').insert(dto.toJson());
  }

  @override
  Future<void> updateRequestStatus(String id, String status) async {
    await client.from('follow_requests').update({'status': status}).eq('id', id);
  }

  @override
  Future<List<FollowRequestModel>> getReceivedRequests(String userId) async {
    final data = await client.from('follow_requests').select().eq('to_user_id', userId).eq('status', 'PENDING');
    return (data as List).map((e) => FollowRequestMapper.toDomain(FollowRequestDto.fromJson(e))).toList();
  }

  @override
  Future<List<FollowRequestModel>> getSentRequests(String userId) async {
    final data = await client.from('follow_requests').select().eq('from_user_id', userId);
    return (data as List).map((e) => FollowRequestMapper.toDomain(FollowRequestDto.fromJson(e))).toList();
  }
}
