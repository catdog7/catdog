import 'package:catdog/data/dto/friend_dto.dart';
import 'package:catdog/domain/model/friend_model.dart';

class FriendMapper {
  static FriendModel toDomain(FriendDto dto) {
    return FriendModel(
      id: dto.id,
      userAId: dto.userAId,
      userBId: dto.userBId,
      createdAt: dto.createdAt,
    );
  }

  static FriendDto toDto(FriendModel model) {
    return FriendDto(
      id: model.id,
      userAId: model.userAId,
      userBId: model.userBId,
      createdAt: model.createdAt,
    );
  }
}
