import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/graph_entity.dart';
import '../repositories/graph_repository.dart';

class GetGraphDataUseCase {
  final GraphRepository repository;

  GetGraphDataUseCase(this.repository);

  Future<Either<Failure, GraphEntity>> call({
    required String filter,
    required String resource,
    bool accumulative = false,
    String? from,
    String? to,
  }) async {
    return await repository.getGraphData(
      filter: filter,
      resource: resource,
      accumulative: accumulative,
      from: from,
      to: to,
    );
  }
}
