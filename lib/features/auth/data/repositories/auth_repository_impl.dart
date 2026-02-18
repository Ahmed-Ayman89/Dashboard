import '../../../../core/network/api_response.dart';
import '../../../../core/network/local_data.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/models/login_request_model.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource = AuthRemoteDataSource();

  @override
  Future<ApiResponse> login(LoginRequestModel loginRequest) async {
    try {
      final response = await _remoteDataSource.login(loginRequest);

      if (response.isSuccess && response.data != null) {
        final data = response.data;
        print("Login Response Data: $data"); // Debug log

        if (data is Map<String, dynamic>) {
          String? accessToken;
          String? refreshToken;

          if (data['data'] != null) {
            final authData = data['data'];
            accessToken = authData['accessToken'] ?? authData['token'];
            refreshToken = authData['refreshToken'];

            final role = authData['admin_role'] ??
                authData['adminRole'] ??
                authData['role'];
            if (role != null) {
              await LocalData.updateRoleAndPermissions(
                  userRole: role, permissions: []);
            }
          } else {
            accessToken = data['accessToken'] ?? data['token'];
            refreshToken = data['refreshToken'];

            final role =
                data['admin_role'] ?? data['adminRole'] ?? data['role'];
            if (role != null) {
              await LocalData.updateRoleAndPermissions(
                  userRole: role, permissions: []);
            }
          }

          print("Parsed Access Token: $accessToken"); // Debug log

          if (accessToken != null) {
            await LocalData.saveTokens(
              accessToken: accessToken,
              refreshToken: refreshToken,
            );
          }
        }
      }
      return response;
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  @override
  Future<ApiResponse> deleteFcmToken(String token) async {
    try {
      return await _remoteDataSource.deleteFcmToken(token);
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  @override
  Future<void> logout() async {
    await LocalData.clear();
  }

  @override
  Future<ApiResponse> setPassword(String password) async {
    try {
      return await _remoteDataSource.setPassword(password);
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  @override
  Future<ApiResponse> verifyToken() async {
    try {
      final response = await _remoteDataSource.verifyToken();
      return response;
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }
}
