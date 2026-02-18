import 'package:dartz/dartz.dart';
import 'package:dashboard_grow/core/error/failures.dart';
import 'package:dashboard_grow/features/system_alerts/data/datasources/alerts_remote_data_source.dart';
import 'package:dashboard_grow/features/system_alerts/data/models/system_alert_model.dart';
import 'package:dashboard_grow/features/system_alerts/domain/repositories/alerts_repository.dart';

class AlertsRepositoryImpl implements AlertsRepository {
  final AlertsRemoteDataSource remoteDataSource;

  AlertsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, SystemAlertResponse>> getSystemAlerts({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await remoteDataSource.getSystemAlerts(
        page: page,
        limit: limit,
      );
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
