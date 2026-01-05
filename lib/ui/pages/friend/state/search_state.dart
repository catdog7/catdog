import 'package:catdog/domain/model/friend_info_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_state.freezed.dart';

@freezed
abstract class SearchState with _$SearchState {
  const factory SearchState({
    required bool isLoading,
    required List<FriendInfoModel> users,
  }) = _SearchState;
}
