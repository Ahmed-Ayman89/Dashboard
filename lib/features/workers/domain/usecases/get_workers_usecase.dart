import '../../../../core/network/api_response.dart';
import '../repositories/workers_repository.dart';

class GetWorkersUseCase {
  final WorkersRepository _repository;

  GetWorkersUseCase(this._repository);

  Future<ApiResponse> call({int page = 1, int limit = 10, String? search}) {
    return _repository.getWorkers(page: page, limit: limit, search: search);
  }
}
