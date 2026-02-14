import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/graph_entity.dart';
import '../../domain/repositories/graph_repository.dart';
import '../datasources/dashboard_remote_data_source.dart';
import '../models/graph_response_model.dart';

class GraphRepositoryImpl implements GraphRepository {
  final DashboardRemoteDataSource remoteDataSource;

  GraphRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, GraphEntity>> getGraphData({
    required String filter,
    required String resource,
    bool accumulative = false,
    String? from,
    String? to,
  }) async {
    try {
      final response = await remoteDataSource.getGraphData(
        filter: filter,
        resource: resource,
        accumulative: accumulative,
        from: from,
        to: to,
      );

      if (response.isSuccess) {
        final graphModel = GraphResponseModel.fromJson(response.data);
        return Right(graphModel.toEntity());
      } else {
        return Left(
            ServerFailure(message: response.message ?? 'Unknown error'));
      }
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
