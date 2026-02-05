import '../../../../core/network/api_response.dart';
import '../repositories/customers_repository.dart';

class GetCustomersUseCase {
  final CustomersRepository _repository;

  GetCustomersUseCase(this._repository);

  Future<ApiResponse> call({int page = 1, int limit = 10, String? search}) {
    return _repository.getCustomers(page: page, limit: limit, search: search);
  }
}
