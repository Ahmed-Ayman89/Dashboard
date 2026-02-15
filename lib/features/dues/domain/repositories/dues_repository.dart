import 'package:dartz/dartz.dart';
import 'package:dashboard_grow/core/error/failures.dart';
import 'package:dashboard_grow/features/dues/data/models/due_model.dart';

import 'package:dashboard_grow/features/dues/data/models/dues_dashboard_model.dart';

abstract class DuesRepository {
  Future<Either<Failure, DueResponseModel>> getDues(
      {int page = 1, int limit = 10});
  Future<Either<Failure, DuesDashboardModel>> getDuesDashboard();
  Future<Either<Failure, String>> collectDue(String dueId, double amount);
}
