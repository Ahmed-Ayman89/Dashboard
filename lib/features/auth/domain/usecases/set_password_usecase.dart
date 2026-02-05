import '../../../../core/network/api_response.dart';
import '../repositories/auth_repository.dart';

class SetPasswordUseCase {
  final AuthRepository _repository;

  SetPasswordUseCase(this._repository);

  Future<ApiResponse> call(String password) async {
    return await _repository.setPassword(password);
  }
}
