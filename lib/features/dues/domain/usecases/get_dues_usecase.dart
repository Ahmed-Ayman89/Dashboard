import 'package:dartz/dartz.dart';
import 'package:dashboard_grow/core/error/failures.dart';
import 'package:dashboard_grow/features/dues/data/models/due_model.dart';
import 'package:dashboard_grow/features/dues/domain/repositories/dues_repository.dart';

class GetDuesUseCase {
  final DuesRepository repository;

  GetDuesUseCase({required this.repository});

  Future<Either<Failure, DueResponseModel>> call({
    int page = 1,
    int limit = 10,
  }) async {
    return await repository.getDues(page: page, limit: limit);
  }
}
