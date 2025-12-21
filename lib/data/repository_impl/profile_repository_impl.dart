import 'package:amumal/core/utils/device_id.dart';
import 'package:amumal/data/dto/user_dto.dart';
import 'package:amumal/data/mapper/user_mapper.dart';
import 'package:amumal/domain/model/user_model.dart';
import 'package:amumal/domain/repository/profile_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({required this.db});
  final FirebaseFirestore db;

  CollectionReference<Map<String, dynamic>> get _userCollection =>
      db.collection('users');

  @override
  Future<void> addProfile({required UserModel user}) async {
    
    final myDeviceId = await getDeviceId();
    final userdata = user.copyWith(id: myDeviceId);
    final dto = UserMapper.toDto(userdata);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profileId', myDeviceId);
    await _userCollection.doc(myDeviceId).set(dto.toJson());
  }

  @override
  Future<UserModel> getProfile() async {
    final myDeviceId = await getDeviceId();
    final snapshot = await _userCollection.doc(myDeviceId).get();
    final data = snapshot.data();
    if (data == null) {
      throw Exception("내 프로필이 존재하지 않습니다.");
    }
    final dto = UserDto.fromDoc(snapshot);
    return UserMapper.toDomain(UserDto.fromJson(data).copyWith(id: snapshot.id));
  }

  @override
  Future<bool> nicknameAvailable(
    {required String nickname}) async {
    final query = await _userCollection
        .where('nickname', isEqualTo: nickname)
        .limit(1)
        .get();

    return query.docs.isEmpty; // true면 사용 가능
  }
}
