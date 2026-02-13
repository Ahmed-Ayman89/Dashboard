import '../../../../core/network/api_response.dart';
import '../../data/models/login_request_model.dart';

abstract class AuthRepository {
  Future<ApiResponse> login(LoginRequestModel loginRequest);
  Future<ApiResponse> deleteFcmToken(String token);
  Future<void> logout();
  Future<ApiResponse> setPassword(String password);
  Future<ApiResponse> verifyToken();
}
