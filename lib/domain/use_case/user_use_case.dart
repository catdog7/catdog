import 'package:catdog/domain/model/user_model.dart';
import 'package:catdog/domain/repository/user_repository.dart';
import 'package:random_string/random_string.dart';

class UserUseCase {
  final UserRepository _repository;

  UserUseCase(this._repository);

  Future<UserModel?> getUserProfile(String id) {
    return _repository.getUser(id);
  }

  Future<bool> hasNickname(String id) async {
    // 먼저 user가 존재하는지 확인
    final user = await _repository.getUser(id);
    
    // user가 없으면 생성 (invite_code를 랜덤 문자열 6자리로 생성, 중복 체크 후 저장)
    if (user == null) {
      final inviteCode = await generateUniqueInviteCode();
      await _repository.createUserIfNotExists(id, inviteCode);
      return false; // 새로 생성된 user는 nickname이 없음
    }
    
    // Repository에서 직접 nickname만 조회하여 체크 (더 정확함)
    return _repository.hasNickname(id);
  }

  Future<void> registerUser(UserModel user) {
    return _repository.addUser(user);
  }

  Future<void> updateProfile(UserModel user) {
    return _repository.updateUser(user);
  }

  Future<void> updateNickname(String id, String nickname) async {
    // Repository의 updateNickname을 사용하여 nickname만 업데이트
    // (도메인 규칙 검증은 이미 사용자 입력 단계에서 완료되었으므로 여기서는 검증하지 않음)
    await _repository.updateNickname(id, nickname);
  }

  /// 사용자 입력 닉네임만 검증 (도메인 규칙: 3-10자)
  void validateUserInputNickname(String userInput) {
    final trimmed = userInput.trim();
    
    if (trimmed.length < 3) {
      throw ArgumentError(
        '닉네임은 3글자 이상이어야 합니다. (현재: ${trimmed.length}자)',
        'nickname',
      );
    }
    
    if (trimmed.length > 10) {
      throw ArgumentError(
        '닉네임은 10글자 이하여야 합니다. (현재: ${trimmed.length}자)',
        'nickname',
      );
    }
  }

  /// 사용자 입력 닉네임에 "_"와 5자리 랜덤 문자열을 붙여서 중복되지 않는 닉네임 생성
  /// 사용자 입력 부분만 검증 (3-10자)
  Future<String> generateUniqueNickname(String userInput) async {
    // 사용자 입력 부분만 검증 (도메인 규칙: 3-10자)
    validateUserInputNickname(userInput);
    
    int maxAttempts = 100; // 무한 루프 방지
    int attempts = 0;

    while (attempts < maxAttempts) {
      // 사용자 입력 + "_" + 5자리 랜덤 문자열
      final randomSuffix = randomAlphaNumeric(5);
      final finalNickname = '${userInput}_$randomSuffix';

      // 중복 체크
      final isDuplicate = await _repository.nicknameExists(finalNickname);
      
      if (!isDuplicate) {
        return finalNickname;
      }
      
      attempts++;
    }

    throw Exception('닉네임 생성에 실패했습니다. 다시 시도해주세요.');
  }

  /// 랜덤 문자열 6자리로 중복되지 않는 invite code 생성
  Future<String> generateUniqueInviteCode() async {
    int maxAttempts = 100; // 무한 루프 방지
    int attempts = 0;

    while (attempts < maxAttempts) {
      // 6자리 랜덤 문자열 생성
      final inviteCode = randomAlphaNumeric(6);

      // 중복 체크
      final isDuplicate = await _repository.inviteCodeExists(inviteCode);
      
      if (!isDuplicate) {
        return inviteCode;
      }
      
      attempts++;
    }

    throw Exception('Invite code 생성에 실패했습니다. 다시 시도해주세요.');
  }
}
