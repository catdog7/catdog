import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    String? id,
    required String nickname,
    required DateTime createdAt,
  }) = _UserModel;
}
