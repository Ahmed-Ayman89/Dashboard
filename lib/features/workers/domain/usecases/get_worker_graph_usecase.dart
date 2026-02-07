import '../../../../core/network/api_response.dart';
import '../../domain/repositories/workers_repository.dart';

class GetWorkerGraphUseCase {
  final WorkersRepository _repository;

  GetWorkerGraphUseCase(this._repository);

  Future<ApiResponse> call(
      {required String id,
      String resource = 'transactions_amount',
      String filter = 'weekly'}) async {
    return await _repository.getWorkerGraph(
        id: id, resource: resource, filter: filter);
  }
}
