import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/datasources/dashboard_remote_data_source.dart';
import '../../data/models/dashboard_stats_model.dart';
import '../../domain/entities/dashboard_stats_entity.dart';
import '../../domain/repositories/dashboard_stats_repository.dart';

class DashboardStatsRepositoryImpl implements DashboardStatsRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardStatsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, DashboardStatsEntity>> getDashboardStats() async {
    try {
      final response = await remoteDataSource.getDashboardStats();

      if (response.isSuccess) {
        final statsModel = DashboardStatsModel.fromJson(response.data);
        return Right(statsModel.toEntity());
      } else {
        return Left(ServerFailure(
          message: response.message ?? 'Unknown error',
          errorCode: response.errorCode,
        ));
      }
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
