import '../../../../core/network/api_response.dart';
import '../repositories/owners_repository.dart';

class PerformOwnerActionUseCase {
  final OwnersRepository repository;

  PerformOwnerActionUseCase(this.repository);

  Future<ApiResponse> call({
    required String id,
    required String action,
    required String reason,
  }) async {
    return await repository.performAction(
      id: id,
      action: action,
      reason: reason,
    );
  }
}
