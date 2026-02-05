import '../../../../core/network/api_response.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_data_source.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource _remoteDataSource =
      DashboardRemoteDataSource();

  @override
  Future<DashboardEntity> getDashboardData() async {
    // Mock data for now
    await Future.delayed(const Duration(seconds: 1));
    return DashboardEntity(
      title: 'Growth Dashboard',
      totalUsers: 1543,
      activeSessions: 42,
    );
  }

  @override
  Future<ApiResponse> getAuditLogs({int page = 1, int limit = 20}) async {
    try {
      return await _remoteDataSource.getAuditLogs(page: page, limit: limit);
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }
}
