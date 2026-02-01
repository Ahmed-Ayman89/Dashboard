import '../../domain/entities/dashboard_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
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
}
