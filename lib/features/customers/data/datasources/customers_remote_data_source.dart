import '../../../../core/network/api_endpoiont.dart';
import '../../../../core/network/api_helper.dart';
import '../../../../core/network/api_response.dart';

class CustomersRemoteDataSource {
  Future<ApiResponse> getCustomers({
    int page = 1,
    int limit = 10,
    String? search,
  }) async {
    try {
      final Map<String, dynamic> queryParameters = {
        'page': page,
        'limit': limit,
      };

      if (search != null && search.isNotEmpty) {
        queryParameters['search'] = search;
      }

      final response = await APIHelper().getRequest(
        endPoint: EndPoints.customers,
        queryParameters: queryParameters,
      );
      return response;
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  Future<ApiResponse> getCustomerDetails(String id) async {
    try {
      final response = await APIHelper().getRequest(
        endPoint: '${EndPoints.customers}/$id',
      );
      return response;
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  Future<ApiResponse> adjustCustomerBalance({
    required String id,
    required double amount,
    required String reason,
  }) async {
    try {
      final response = await APIHelper().postRequest(
        endPoint: '${EndPoints.customers}/$id/balance',
        data: {
          'amount': amount,
          'reason': reason,
        },
        isFormData: false,
      );
      return response;
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  Future<ApiResponse> updateCustomerStatus({
    required String id,
    required String status,
    required String note,
  }) async {
    try {
      final response = await APIHelper().postRequest(
        endPoint: '${EndPoints.customers}/$id/status',
        data: {
          'status': status,
          'note': note,
        },
        isFormData: false,
      );
      return response;
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }
}
