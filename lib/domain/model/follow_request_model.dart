import 'package:freezed_annotation/freezed_annotation.dart';

part 'follow_request_model.freezed.dart';

@freezed
class FollowRequestModel with _$FollowRequestModel {
  const factory FollowRequestModel({
    required String id,
    required String fromUserId,
    required String toUserId,
    @Default('PENDING') String status,
    @Default('FRIEND') String type,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _FollowRequestModel;
}
