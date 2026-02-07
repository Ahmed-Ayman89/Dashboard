import 'package:dartz/dartz.dart';
import 'package:dashboard_grow/core/error/failures.dart';
import 'package:dashboard_grow/features/dues/data/models/dues_dashboard_model.dart';
import 'package:dashboard_grow/features/dues/domain/repositories/dues_repository.dart';

class GetDuesDashboardUseCase {
  final DuesRepository repository;

  GetDuesDashboardUseCase({required this.repository});

  Future<Either<Failure, DuesDashboardModel>> call() async {
    return await repository.getDuesDashboard();
  }
}
