import 'package:amumal/data/dto/user_dto.dart';
import 'package:amumal/data/mapper/user_mapper.dart';
import 'package:amumal/domain/model/user_model.dart';
import 'package:amumal/domain/repository/root_page_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RootPageRepositoryImpl implements RootPageRepository {
  RootPageRepositoryImpl({required this.db});
  
  final FirebaseFirestore db;

  @override
  Future<bool> hasProfile(String deviceId) async {
    final doc = await db.collection('users').doc(deviceId).get();
    return doc.exists;
  }

  @override
  Future<UserModel?> getProfile(String deviceId) async {
    final doc = await db.collection('users').doc(deviceId).get();

    if (!doc.exists) {
      return null;
    }

    final data = doc.data();
    if (data == null) {
      return null;
    }

    final dto = UserDto.fromDoc(doc);
    return UserMapper.toDomain(dto);
  
  }
}
