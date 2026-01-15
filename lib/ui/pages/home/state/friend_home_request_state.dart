import 'package:freezed_annotation/freezed_annotation.dart';

part 'friend_home_request_state.freezed.dart';

@freezed
abstract class FriendHomeRequestState with _$FriendHomeRequestState {
  const factory FriendHomeRequestState({
    required bool isLoading,
    required bool isFriend,
    required bool isSendPending,
    required bool isReceivePending,
  }) = _FriendHomeRequestState;
}
