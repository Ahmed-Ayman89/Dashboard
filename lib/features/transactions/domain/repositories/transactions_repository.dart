import '../../../../core/network/api_response.dart';

abstract class TransactionsRepository {
  Future<ApiResponse> getTransactions({
    int page = 1,
    int limit = 20,
  });
}
