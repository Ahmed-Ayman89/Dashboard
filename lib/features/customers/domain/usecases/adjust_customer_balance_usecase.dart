import '../../../../core/network/api_response.dart';
import '../repositories/customers_repository.dart';

class AdjustCustomerBalanceUseCase {
  final CustomersRepository _repository;

  AdjustCustomerBalanceUseCase(this._repository);

  Future<ApiResponse> call({
    required String id,
    required double amount,
    required String reason,
  }) {
    return _repository.adjustCustomerBalance(
        id: id, amount: amount, reason: reason);
  }
}
