import 'package:freezed_annotation/freezed_annotation.dart';

part 'friend_model.freezed.dart';

@freezed
class FriendModel with _$FriendModel {
  const factory FriendModel({
    required String id,
    required String userAId,
    required String userBId,
    DateTime? createdAt,
  }) = _FriendModel;
}
