import '../../../../core/network/api_response.dart';

abstract class WorkersRepository {
  Future<ApiResponse> getWorkers(
      {int page = 1, int limit = 10, String? search});

  Future<ApiResponse> getWorkerDetails(String id);

  Future<ApiResponse> deleteWorkerById(
      String id, String kioskId, String profileId);

  Future<ApiResponse> banWorkerById(String id);

  Future<ApiResponse> getWorkerGraph({
    required String id,
    String resource = 'transactions_amount',
    String filter = 'weekly',
    bool accumulative = true,
  });
}
