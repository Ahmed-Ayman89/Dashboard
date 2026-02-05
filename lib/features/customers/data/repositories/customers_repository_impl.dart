import '../../../../core/network/api_response.dart';
import '../../data/datasources/customers_remote_data_source.dart';
import '../../domain/repositories/customers_repository.dart';

class CustomersRepositoryImpl implements CustomersRepository {
  final CustomersRemoteDataSource _dataSource = CustomersRemoteDataSource();

  @override
  Future<ApiResponse> getCustomers({
    int page = 1,
    int limit = 10,
    String? search,
  }) async {
    return await _dataSource.getCustomers(
        page: page, limit: limit, search: search);
  }

  @override
  Future<ApiResponse> getCustomerDetails(String id) async {
    return await _dataSource.getCustomerDetails(id);
  }

  @override
  Future<ApiResponse> adjustCustomerBalance({
    required String id,
    required double amount,
    required String reason,
  }) async {
    return await _dataSource.adjustCustomerBalance(
        id: id, amount: amount, reason: reason);
  }

  @override
  Future<ApiResponse> updateCustomerStatus({
    required String id,
    required String status,
    required String note,
  }) async {
    return await _dataSource.updateCustomerStatus(
        id: id, status: status, note: note);
  }
}
