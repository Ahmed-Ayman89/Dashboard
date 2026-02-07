import 'package:dartz/dartz.dart';
import 'package:dashboard_grow/core/error/failures.dart';
import 'package:dashboard_grow/features/dues/domain/entities/due.dart';
import 'package:dashboard_grow/features/dues/domain/repositories/dues_repository.dart';

class GetDuesUseCase {
  final DuesRepository repository;

  GetDuesUseCase({required this.repository});

  Future<Either<Failure, List<Due>>> call() async {
    return await repository.getDues();
  }
}
