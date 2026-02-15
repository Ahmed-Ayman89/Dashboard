import 'package:dartz/dartz.dart';
import 'package:dashboard_grow/core/error/failures.dart';
import 'package:dashboard_grow/features/dues/data/datasources/dues_remote_data_source.dart';
import 'package:dashboard_grow/features/dues/data/models/dues_dashboard_model.dart';
import 'package:dashboard_grow/features/dues/data/models/due_model.dart';
import 'package:dashboard_grow/features/dues/domain/repositories/dues_repository.dart';

class DuesRepositoryImpl implements DuesRepository {
  final DuesRemoteDataSource remoteDataSource;

  DuesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, DueResponseModel>> getDues({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await remoteDataSource.getDues(page: page, limit: limit);
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, DuesDashboardModel>> getDuesDashboard() async {
    try {
      final response = await remoteDataSource.getDuesDashboard();
      return Right(response.data);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> collectDue(
      String dueId, double amount) async {
    try {
      await remoteDataSource.collectDue(dueId, amount);
      return const Right('Due collected successfully');
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
