import '../../../../core/network/api_response.dart';
import '../repositories/dashboard_repository.dart';

class GetAuditLogsUseCase {
  final DashboardRepository _repository;

  GetAuditLogsUseCase(this._repository);

  Future<ApiResponse> call({int page = 1, int limit = 20}) async {
    return await _repository.getAuditLogs(page: page, limit: limit);
  }
}
