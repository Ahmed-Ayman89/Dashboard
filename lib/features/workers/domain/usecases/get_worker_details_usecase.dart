import '../../../../core/network/api_response.dart';
import '../repositories/workers_repository.dart';

class GetWorkerDetailsUseCase {
  final WorkersRepository _repository;

  GetWorkerDetailsUseCase(this._repository);

  Future<ApiResponse> call(String id) {
    return _repository.getWorkerDetails(id);
  }
}
