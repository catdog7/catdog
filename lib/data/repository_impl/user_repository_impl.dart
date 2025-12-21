import 'package:catdog/data/dto/user_dto.dart';
import 'package:catdog/data/mapper/user_mapper.dart';
import 'package:catdog/domain/model/user_model.dart';
import 'package:catdog/domain/repository/user_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({required this.client});
  final SupabaseClient client;

  @override
  Future<void> addUser({required UserModel user}) async {
    final dto = UserMapper.toDto(user);
    await client.from('users').upsert(dto.toJson());
  }

  @override
  Future<UserModel> getUser(String userId) async {
    final data = await client.from('users').select().eq('id', userId).single();
    return UserMapper.toDomain(UserDto.fromJson(data));
  }

  Future<UserModel> getMyProfile() async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) throw Exception("Not authenticated");
    return getUser(userId);
  }

  @override
  Future<bool> hasProfile(String userId) async {
    final data = await client
        .from('users')
        .select('id')
        .eq('id', userId)
        .maybeSingle();
    return data != null;
  }

  @override
  Future<bool> nicknameAvailable({required String nickname}) async {
    final data = await client
        .from('users')
        .select('id')
        .eq('nickname', nickname)
        .maybeSingle();
    return data == null;
  }
}
