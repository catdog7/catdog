abstract interface class FcmRepository {
  Future<void> initPermission();

  Future<String?> getToken();
  Stream<String> onTokenRefresh();

  Future<void> saveToken(String token);
  Future<void> removeToken();
}
