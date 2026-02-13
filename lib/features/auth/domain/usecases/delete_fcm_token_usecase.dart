import '../../../../core/network/api_response.dart';
import '../repositories/auth_repository.dart';

class DeleteFcmTokenUseCase {
  final AuthRepository _repository;

  DeleteFcmTokenUseCase(this._repository);

  Future<ApiResponse> call(String token) async {
    return await _repository.deleteFcmToken(token);
  }
}
