import 'package:catdog/data/dto/follow_request_dto.dart';
import 'package:catdog/domain/model/follow_request_model.dart';

class FollowRequestMapper {
  static FollowRequestModel toDomain(FollowRequestDto dto) {
    return FollowRequestModel(
      id: dto.id,
      fromUserId: dto.fromUserId,
      toUserId: dto.toUserId,
      status: dto.status,
      type: dto.type,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  static FollowRequestDto toDto(FollowRequestModel model) {
    return FollowRequestDto(
      id: model.id,
      fromUserId: model.fromUserId,
      toUserId: model.toUserId,
      status: model.status,
      type: model.type,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }
}
