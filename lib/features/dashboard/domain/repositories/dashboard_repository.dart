import '../../../../core/network/api_response.dart';
import '../entities/dashboard_entity.dart';

abstract class DashboardRepository {
  Future<DashboardEntity> getDashboardData();
  Future<ApiResponse> getAuditLogs({int page = 1, int limit = 20});
}
