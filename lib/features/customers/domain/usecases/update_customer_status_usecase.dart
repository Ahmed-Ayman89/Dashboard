import '../../../../core/network/api_response.dart';
import '../repositories/customers_repository.dart';

class UpdateCustomerStatusUseCase {
  final CustomersRepository _repository;

  UpdateCustomerStatusUseCase(this._repository);

  Future<ApiResponse> call({
    required String id,
    required String status,
    required String note,
  }) {
    return _repository.updateCustomerStatus(id: id, status: status, note: note);
  }
}
