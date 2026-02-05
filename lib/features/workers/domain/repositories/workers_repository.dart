import '../../../../core/network/api_response.dart';

abstract class WorkersRepository {
  Future<ApiResponse> getWorkers(
      {int page = 1, int limit = 10, String? search});

  Future<ApiResponse> getWorkerDetails(String id);
}
