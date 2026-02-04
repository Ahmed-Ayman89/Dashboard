import '../../../../core/network/api_response.dart';
import '../../data/models/login_request_model.dart';
import '../../domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  Future<ApiResponse> call(LoginRequestModel loginRequest) async {
    return await _authRepository.login(loginRequest);
  }
}
