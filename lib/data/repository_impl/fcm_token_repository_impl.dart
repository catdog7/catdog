import 'package:catdog/data/dto/fcm_token_dto.dart';
import 'package:catdog/data/mapper/fcm_mapper.dart';
import 'package:catdog/domain/model/fcm_token_model.dart';
import 'package:catdog/domain/repository/fcm_token_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FcmTokenRepositoryImpl implements FcmTokenRepository {
  FcmTokenRepositoryImpl({required this.client});
  final SupabaseClient client;

  @override
  Future<void> saveToken(FcmTokenModel token) async {
    final dto = FcmMapper.toDto(token);
    await client.from('fcm_tokens').upsert(dto.toJson());
  }

  @override
  Future<void> deleteToken(String userId, String token) async {
    await client.from('fcm_tokens').delete().eq('user_id', userId).eq('token', token);
  }

  @override
  Future<List<FcmTokenModel>> getTokens(String userId) async {
    final data = await client.from('fcm_tokens').select().eq('user_id', userId);
    return (data as List).map((e) => FcmMapper.toDomain(FcmTokenDto.fromJson(e))).toList();
  }
}
