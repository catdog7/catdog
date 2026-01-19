import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required String id,
    required String nickname,
    String? inviteCode,
    String? profileImageUrl,
    String? email,
    String? provider,
    @Default('ACTIVE') String status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  /// 생성자 (user 생성 시 사용)
  /// nickname은 생성 시 없으므로 빈 문자열로 설정
  factory UserModel.create({
    required String id,
    String? inviteCode,
    String? profileImageUrl,
    String? email,
    String? provider,
    String status = 'ACTIVE',
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id,
      nickname: '', // 생성 시 nickname은 없음
      inviteCode: inviteCode,
      profileImageUrl: profileImageUrl,
      email: email,
      provider: provider,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// nickname을 업데이트할 때 사용하는 메서드
  UserModel updateNickname(String newNickname) {
    final trimmedNickname = newNickname.trim();
    
    // 도메인 규칙: nickname은 3글자 이상 10글자 이하여야 함
    if (trimmedNickname.length < 3) {
      throw ArgumentError(
        '닉네임은 3글자 이상이어야 합니다. (현재: ${trimmedNickname.length}자)',
        'nickname',
      );
    }
    
    if (trimmedNickname.length > 10) {
      throw ArgumentError(
        '닉네임은 10글자 이하여야 합니다. (현재: ${trimmedNickname.length}자)',
        'nickname',
      );
    }

    return copyWith(nickname: trimmedNickname);
  }
}
