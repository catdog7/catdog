import 'package:amumal/data/dto/user_dto.dart';
import 'package:amumal/domain/model/user_model.dart';

class UserMapper {
  static UserModel toDomain(UserDto dto) => UserModel(
        id: dto.id,
        nickname: dto.nickname,
        createdAt: dto.createdAt,
      );

  static UserDto toDto(UserModel model) => UserDto(
        id: model.id,
        nickname: model.nickname,
        createdAt: model.createdAt,
      );
}
