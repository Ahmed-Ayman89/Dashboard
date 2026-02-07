import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/dues_repository.dart';

class CollectDueUseCase {
  final DuesRepository repository;

  CollectDueUseCase({required this.repository});

  Future<Either<Failure, String>> call(String dueId, double amount) async {
    return await repository.collectDue(dueId, amount);
  }
}
