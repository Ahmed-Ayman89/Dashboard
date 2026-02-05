import '../../../../core/network/api_helper.dart';
import '../../../../core/network/api_endpoiont.dart';
import '../../../../core/network/api_response.dart';

class TransactionsRemoteDataSource {
  Future<ApiResponse> getTransactions({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await APIHelper().getRequest(
        endPoint: EndPoints.transactions,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );
      return response;
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }
}
