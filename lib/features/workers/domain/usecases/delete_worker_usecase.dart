import '../../../../core/network/api_response.dart';
import '../repositories/workers_repository.dart';

class DeleteWorkerUseCase {
  final WorkersRepository _repository;

  DeleteWorkerUseCase(this._repository);

  Future<ApiResponse> call(String id, String kioskId, String profileId) async {
    return await _repository.deleteWorkerById(id, kioskId, profileId);
  }
}
