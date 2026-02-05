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
}
