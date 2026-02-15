import '../../../../core/network/api_response.dart';
import '../../data/datasources/workers_remote_data_source.dart';
import '../../domain/repositories/workers_repository.dart';

class WorkersRepositoryImpl implements WorkersRepository {
  final WorkersRemoteDataSource _dataSource = WorkersRemoteDataSource();

  WorkersRepositoryImpl();

  @override
  Future<ApiResponse> getWorkers({
    int page = 1,
    int limit = 10,
    String? search,
  }) async {
    return await _dataSource.getWorkers(
        page: page, limit: limit, search: search);
  }

  @override
  Future<ApiResponse> getWorkerDetails(String id) async {
    return await _dataSource.getWorkerDetails(id);
  }

  @override
  Future<ApiResponse> deleteWorkerById(
      String id, String kioskId, String profileId) async {
    return await _dataSource.deleteWorker(id, kioskId, profileId);
  }

  @override
  Future<ApiResponse> banWorkerById(String id) async {
    return await _dataSource.banWorker(id);
  }

  @override
  Future<ApiResponse> getWorkerGraph({
    required String id,
    String resource = 'transactions_amount',
    String filter = 'weekly',
    bool accumulative = true,
  }) async {
    return await _dataSource.getWorkerGraph(
      id: id,
      resource: resource,
      filter: filter,
      accumulative: accumulative, // Calling data source with new parameter
    );
  }
}
