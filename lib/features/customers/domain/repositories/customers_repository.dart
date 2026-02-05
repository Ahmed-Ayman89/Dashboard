import '../../../../core/network/api_response.dart';

abstract class CustomersRepository {
  Future<ApiResponse> getCustomers(
      {int page = 1, int limit = 10, String? search});
  Future<ApiResponse> getCustomerDetails(String id);
  Future<ApiResponse> adjustCustomerBalance(
      {required String id, required double amount, required String reason});
  Future<ApiResponse> updateCustomerStatus(
      {required String id, required String status, required String note});
}
