import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String nickname,
    required String inviteCode,
    String? profileImageUrl,
    @Default('ACTIVE') String status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserModel;
}
