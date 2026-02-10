import '../../../../core/network/api_response.dart';
import '../repositories/auth_repository.dart';

class VerifyTokenUseCase {
  final AuthRepository _repository;

  VerifyTokenUseCase(this._repository);

  Future<ApiResponse> call() async {
    return await _repository.verifyToken();
  }
}
