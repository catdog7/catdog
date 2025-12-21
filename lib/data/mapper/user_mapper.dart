import 'package:catdog/data/dto/user_dto.dart';
import 'package:catdog/domain/model/user_model.dart';

class UserMapper {
  static UserModel toDomain(UserDto dto) => UserModel(
        id: dto.id,
        nickname: dto.nickname,
        inviteCode: dto.inviteCode,
        profileImageUrl: dto.profileImageUrl,
        status: dto.status,
        createdAt: dto.createdAt,
        updatedAt: dto.updatedAt,
      );

  static UserDto toDto(UserModel model) => UserDto(
        id: model.id,
        nickname: model.nickname,
        inviteCode: model.inviteCode,
        profileImageUrl: model.profileImageUrl,
        status: model.status,
        createdAt: model.createdAt,
        updatedAt: model.updatedAt,
      );
}
