import '../../../../core/network/api_response.dart';
import '../../domain/repositories/transactions_repository.dart';
import '../datasources/transactions_remote_data_source.dart';

class TransactionsRepositoryImpl implements TransactionsRepository {
  final TransactionsRemoteDataSource _remoteDataSource =
      TransactionsRemoteDataSource();

  @override
  Future<ApiResponse> getTransactions({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      return await _remoteDataSource.getTransactions(
        page: page,
        limit: limit,
      );
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }
}
