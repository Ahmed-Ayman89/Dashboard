import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/graph_entity.dart';

abstract class GraphRepository {
  Future<Either<Failure, GraphEntity>> getGraphData({
    required String filter,
    required String resource,
    bool accumulative = false,
    String? from,
    String? to,
  });
}
