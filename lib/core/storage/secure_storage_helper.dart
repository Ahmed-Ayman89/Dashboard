import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  // Private constructor
  SecureStorageHelper._();

  // Singleton instance
  static final SecureStorageHelper instance = SecureStorageHelper._();

  // FlutterSecureStorage instance
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Keys
  static const String _keyToken = 'auth_token';
  static const String _keyUserData = 'user_data';
  static const String _keyOtpToken = 'otp_token';
  static const String _keyActiveWorkerProfileId = 'active_worker_profile_id';

  /// Save the authentication token
  Future<void> saveToken(String token) async {
    print('SecureStorageHelper: Saving token: $token');
    await _storage.write(key: _keyToken, value: token);
  }

  /// Get the authentication token
  Future<String?> getToken() async {
    final token = await _storage.read(key: _keyToken);
    print('SecureStorageHelper: Retrieved token: $token');
    return token;
  }

  /// Delete the authentication token
  Future<void> deleteToken() async {
    await _storage.delete(key: _keyToken);
  }

  /// Save user data (stores as JSON string)
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    String jsonString = jsonEncode(userData);
    print('SecureStorageHelper: Saving user data: $jsonString');
    await _storage.write(key: _keyUserData, value: jsonString);
  }

  /// Get user data
  Future<Map<String, dynamic>?> getUserData() async {
    String? jsonString = await _storage.read(key: _keyUserData);
    print('SecureStorageHelper: Retrieved user data string: $jsonString');
    if (jsonString != null) {
      try {
        return jsonDecode(jsonString) as Map<String, dynamic>;
      } catch (e) {
        // Handle decode error if necessary, or return null
        return null;
      }
    }
    return null;
  }

  /// Delete user data
  Future<void> deleteUserData() async {
    await _storage.delete(key: _keyUserData);
  }

  // --- OTP Token Methods ---

  /// Save the OTP verification token
  Future<void> saveOtpToken(String token) async {
    await _storage.write(key: _keyOtpToken, value: token);
  }

  /// Get the OTP verification token
  Future<String?> getOtpToken() async {
    return await _storage.read(key: _keyOtpToken);
  }

  /// Delete the OTP verification token
  Future<void> deleteOtpToken() async {
    await _storage.delete(key: _keyOtpToken);
  }

  /// Clear all data (Useful for logout)
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// Save the active worker profile ID
  Future<void> saveActiveWorkerProfileId(String id) async {
    await _storage.write(key: _keyActiveWorkerProfileId, value: id);
  }

  /// Get the active worker profile ID
  Future<String?> getActiveWorkerProfileId() async {
    return await _storage.read(key: _keyActiveWorkerProfileId);
  }
}
