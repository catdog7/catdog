import 'package:catdog/data/dto/user_dto.dart';
import 'package:catdog/data/mapper/user_mapper.dart';
import 'package:catdog/domain/model/user_model.dart';
import 'package:catdog/domain/repository/user_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserRepositoryImpl implements UserRepository {
  final SupabaseClient _client;

  UserRepositoryImpl(this._client);

  @override
  Future<UserModel?> getUser(String id) async {
    final response = await _client
        .from('users')
        .select()
        .eq('id', id)
        .maybeSingle();
    
    if (response == null) return null;
    return UserMapper.toModel(UserDto.fromJson(response));
  }

  @override
  Future<void> addUser(UserModel user) async {
    final dto = UserMapper.toDto(user);
    await _client.from('users').insert(dto.toJson());
  }

  @override
  Future<void> updateUser(UserModel user) async {
    final dto = UserMapper.toDto(user);
    await _client.from('users').update(dto.toJson()).eq('id', user.id);
  }
}
