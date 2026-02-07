import 'package:dartz/dartz.dart';
import 'package:dashboard_grow/core/error/failures.dart';
import 'package:dashboard_grow/features/dues/domain/entities/due.dart';

import 'package:dashboard_grow/features/dues/data/models/dues_dashboard_model.dart';

abstract class DuesRepository {
  Future<Either<Failure, List<Due>>> getDues();
  Future<Either<Failure, DuesDashboardModel>> getDuesDashboard();
  Future<Either<Failure, String>> collectDue(String dueId, double amount);
}
