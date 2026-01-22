import 'package:freezed_annotation/freezed_annotation.dart';

part 'friend_info_model.freezed.dart';

@freezed
class FriendInfoModel with _$FriendInfoModel {
  const factory FriendInfoModel({
    required String userId,
    String? nickname,
    required bool isFriend,
    String? status,
    String? profileImageUrl,
  }) = _FriendInfoModel;
}
