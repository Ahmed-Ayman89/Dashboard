import '../../../../core/network/api_response.dart';
import '../repositories/workers_repository.dart';

class BanWorkerUseCase {
  final WorkersRepository _repository;

  BanWorkerUseCase(this._repository);

  Future<ApiResponse> call(String id) async {
    return await _repository.banWorkerById(id);
  }
}
