import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalData {
  static String? accessToken;
  static String? refreshToken;
  static String? userName;

  static const _storage = FlutterSecureStorage();
  static const _accessTokenKey = 'auth_token';
  static const _refreshTokenKey = 'REFRESH_TOKEN';

  static const String _userIdKey = 'user_id';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';
  static const String _userRoleKey = 'user_role';
  static const String _tempTokenKey = 'temp_token';
  static const String _passcodeKey = 'user_passcode';

  static Future<void> init() async {
    accessToken = await _storage.read(key: _accessTokenKey);
    refreshToken = await _storage.read(key: _refreshTokenKey);
    userName = await _storage.read(key: _userNameKey);
  }

  static Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    print("accessToken $accessToken");
    LocalData.accessToken = accessToken;
    LocalData.refreshToken = refreshToken;
    await _storage.write(key: _accessTokenKey, value: accessToken);
    if (refreshToken != null) {
      await _storage.write(key: _refreshTokenKey, value: refreshToken);
    }
  }

  static Future<void> clear() async {
    LocalData.accessToken = null;
    LocalData.refreshToken = null;
    await _storage.deleteAll();
  }

  static Future<void> saveUserData({
    required String userId,
    required String userName,
    required String userEmail,
    required String userRole,
    List<String>? permissions,
  }) async {
    await _storage.write(key: _userIdKey, value: userId);
    await _storage.write(key: _userNameKey, value: userName);
    LocalData.userName = userName;
    await _storage.write(key: _userEmailKey, value: userEmail);
    await _storage.write(key: _userRoleKey, value: userRole);
  }

  static Future<void> updateRoleAndPermissions({
    required String userRole,
    required List<String> permissions,
  }) async {
    await _storage.write(key: _userRoleKey, value: userRole);
  }

  static Future<Map<String, String?>> getUserData() async {
    return {
      'userId': await _storage.read(key: _userIdKey),
      'userName': await _storage.read(key: _userNameKey),
      'userEmail': await _storage.read(key: _userEmailKey),
      'userRole': await _storage.read(key: _userRoleKey),
    };
  }

  static Future<String?> getUserRole() async {
    return await _storage.read(key: _userRoleKey);
  }

  static Future<void> saveRegistrationToken(String token) async {
    await _storage.write(key: _tempTokenKey, value: token);
  }

  static Future<String?> getRegistrationToken() async {
    return await _storage.read(key: _tempTokenKey);
  }

  static Future<void> savePasscode(String passcode) async {
    await _storage.write(key: _passcodeKey, value: passcode);
  }

  static Future<String?> getPasscode() async {
    return await _storage.read(key: _passcodeKey);
  }

  static const String _preAuthTokenKey = 'pre_auth_token';

  static Future<void> savePreAuthToken(String token) async {
    await _storage.write(key: _preAuthTokenKey, value: token);
  }

  static Future<String?> getPreAuthToken() async {
    return await _storage.read(key: _preAuthTokenKey);
  }
}
