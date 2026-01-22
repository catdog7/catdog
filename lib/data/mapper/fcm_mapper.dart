import 'package:catdog/data/dto/fcm_token_dto.dart';
import 'package:catdog/domain/model/fcm_token_model.dart';

class FcmMapper {
  static FcmTokenModel toDomain(FcmTokenDto dto) => FcmTokenModel(
        id: dto.id,
        userId: dto.userId,
        token: dto.token,
        platform: dto.platform,
        createdAt: dto.createdAt,
      );

  static FcmTokenDto toDto(FcmTokenModel model) => FcmTokenDto(
        id: model.id,
        userId: model.userId,
        token: model.token,
        platform: model.platform,
        createdAt: model.createdAt,
      );
}
