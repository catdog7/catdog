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
    try {
      final response = await _client
          .from('users')
          .select()
          .eq('id', id)
          .maybeSingle();
      
      if (response == null) return null;
      
      // UserDto의 required 필드들이 null인 경우를 처리
      final responseCopy = Map<String, dynamic>.from(response);
      
      // id가 null인 경우 처리 (필수 필드)
      if (responseCopy['id'] == null) {
        responseCopy['id'] = id; // 파라미터로 받은 id 사용
      }
      
      // nickname이 null이거나 빈 문자열인 경우 빈 문자열로 설정
      if (responseCopy['nickname'] == null || 
          (responseCopy['nickname'] is String && (responseCopy['nickname'] as String).trim().isEmpty)) {
        responseCopy['nickname'] = '';
      }
      
      // invite_code가 null인 경우 빈 문자열로 설정 (스키마상 nullable이지만 DTO는 required)
      if (responseCopy['invite_code'] == null) {
        responseCopy['invite_code'] = '';
      }
      
      return UserMapper.toModel(UserDto.fromJson(responseCopy));
    } catch (e) {
      print('getUser error: $e');
      return null;
    }
  }

  @override
  Future<bool> hasNickname(String id) async {
    try {
      final response = await _client
          .from('users')
          .select('nickname')
          .eq('id', id)
          .maybeSingle();
      
      if (response == null) return false;
      
      final nickname = response['nickname'];
      if (nickname == null) return false;
      
      final nicknameStr = nickname.toString().trim();
      return nicknameStr.isNotEmpty;
    } catch (e) {
      print('hasNickname error: $e');
      return false;
    }
  }

  @override
  Future<bool> nicknameExists(String nickname) async {
    try {
      final response = await _client
          .from('users')
          .select('id')
          .eq('nickname', nickname)
          .maybeSingle();
      
      return response != null;
    } catch (e) {
      print('nicknameExists error: $e');
      return false;
    }
  }

  @override
  Future<bool> inviteCodeExists(String inviteCode) async {
    try {
      final response = await _client
          .from('users')
          .select('id')
          .eq('invite_code', inviteCode)
          .maybeSingle();
      
      return response != null;
    } catch (e) {
      print('inviteCodeExists error: $e');
      return false;
    }
  }

  @override
  Future<void> addUser(UserModel user) async {
    final dto = UserMapper.toDto(user);
    await _client.from('users').insert(dto.toJson());
  }

  @override
  Future<void> createUserIfNotExists(String id, String inviteCode, {String? email, String? provider}) async {
    // user가 이미 존재하는지 확인
    final existing = await getUser(id);
    if (existing != null) return; // 이미 존재하면 생성하지 않음
    
    // auth 정보에서 email과 provider 가져오기
    final session = _client.auth.currentSession;
    final userEmail = email ?? session?.user.email;
    final userProvider = provider ?? (session != null ? session.user.appMetadata['provider'] as String? : null);
    
    // user 생성 (email, provider, createdAt 포함)
    final newUser = UserModel.create(
      id: id,
      inviteCode: inviteCode,
      email: userEmail,
      provider: userProvider,
      createdAt: DateTime.now(),
    );
    
    await addUser(newUser);
  }

  @override
  Future<void> updateUser(UserModel user) async {
    final dto = UserMapper.toDto(user);
    await _client.from('users').update(dto.toJson()).eq('id', user.id);
  }

  @override
  Future<void> updateNickname(String id, String nickname) async {
    try {
      // nickname만 업데이트 (invite_code는 건드리지 않음)
      final result = await _client
          .from('users')
          .update({'nickname': nickname})
          .eq('id', id)
          .select();
      
      // 업데이트된 행이 없으면 user가 없는 것이므로 생성 필요
      if (result.isEmpty) {
        throw Exception('User not found. Please create user first.');
      }
    } catch (e) {
      print('updateNickname error: $e');
      rethrow;
    }
  }
}
