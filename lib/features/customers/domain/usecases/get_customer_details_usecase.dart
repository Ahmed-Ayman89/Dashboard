import '../../../../core/network/api_response.dart';
import '../repositories/customers_repository.dart';

class GetCustomerDetailsUseCase {
  final CustomersRepository _repository;

  GetCustomerDetailsUseCase(this._repository);

  Future<ApiResponse> call(String id) {
    return _repository.getCustomerDetails(id);
  }
}
