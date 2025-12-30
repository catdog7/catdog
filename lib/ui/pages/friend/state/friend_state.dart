import 'package:catdog/domain/model/friend_info_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'friend_state.freezed.dart';

@freezed
abstract class FriendState with _$FriendState {
  const factory FriendState({
    required bool isLoading,
    required List<FriendInfoModel> friends,
  }) = _FriendState;
}
