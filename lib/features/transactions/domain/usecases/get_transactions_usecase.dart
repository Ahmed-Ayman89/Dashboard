import '../../../../core/network/api_response.dart';
import '../repositories/transactions_repository.dart';

class GetTransactionsUseCase {
  final TransactionsRepository repository;

  GetTransactionsUseCase(this.repository);

  Future<ApiResponse> call({int page = 1, int limit = 20}) async {
    return await repository.getTransactions(page: page, limit: limit);
  }
}
