import 'package:dartz/dartz.dart';
import 'package:dashboard_grow/core/error/failures.dart';
import 'package:dashboard_grow/features/system_alerts/data/models/system_alert_model.dart';
import 'package:dashboard_grow/features/system_alerts/domain/repositories/alerts_repository.dart';

class GetSystemAlertsUseCase {
  final AlertsRepository repository;

  GetSystemAlertsUseCase(this.repository);

  Future<Either<Failure, SystemAlertResponse>> call({
    int page = 1,
    int limit = 10,
  }) async {
    return await repository.getSystemAlerts(page: page, limit: limit);
  }
}
