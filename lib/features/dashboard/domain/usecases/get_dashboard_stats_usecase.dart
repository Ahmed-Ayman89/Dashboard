import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/dashboard_stats_entity.dart';
import '../repositories/dashboard_stats_repository.dart';

class GetDashboardStatsUseCase {
  final DashboardStatsRepository repository;

  GetDashboardStatsUseCase(this.repository);

  Future<Either<Failure, DashboardStatsEntity>> call() async {
    return await repository.getDashboardStats();
  }
}
