import '../../../../core/network/api_response.dart';
import '../../data/models/login_request_model.dart';

abstract class AuthRepository {
  Future<ApiResponse> login(LoginRequestModel loginRequest);
}
