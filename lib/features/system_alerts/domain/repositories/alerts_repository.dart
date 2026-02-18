import 'package:dartz/dartz.dart';
import 'package:dashboard_grow/core/error/failures.dart';
import 'package:dashboard_grow/features/system_alerts/data/models/system_alert_model.dart';

abstract class AlertsRepository {
  Future<Either<Failure, SystemAlertResponse>> getSystemAlerts({
    int page = 1,
    int limit = 10,
  });
}
