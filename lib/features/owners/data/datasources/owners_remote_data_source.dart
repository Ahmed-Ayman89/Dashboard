import '../../../../core/network/api_helper.dart';
import '../../../../core/network/api_endpoiont.dart';
import '../../../../core/network/api_response.dart';

class OwnersRemoteDataSource {
  Future<ApiResponse> getOwners({
    int page = 1,
    int limit = 10,
    String search = '',
    String? status,
  }) async {
    try {
      final Map<String, dynamic> queryParameters = {
        'page': page,
        'limit': limit,
        'search': search,
      };

      if (status != null && status.isNotEmpty && status != 'All') {
        queryParameters['status'] = status.toUpperCase();
      }

      final response = await APIHelper().getRequest(
        endPoint: EndPoints.owners,
        queryParameters: queryParameters,
      );
      return response;
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  Future<ApiResponse> getOwnerDetails(String id) async {
    try {
      final response = await APIHelper().getRequest(
        endPoint: '${EndPoints.owners}/$id',
      );
      return response;
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  Future<ApiResponse> performAction({
    required String id,
    required String action,
    required String reason,
  }) async {
    try {
      final response = await APIHelper().postRequest(
        isFormData: false,
        endPoint: '${EndPoints.owners}/$id/action',
        data: {
          'action': action,
          'reason': reason,
        },
      );
      return response;
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  Future<ApiResponse> getOwnerGraph({
    required String id,
    String resource = 'transactions_amount',
    String filter = 'weekly',
  }) async {
    try {
      final response = await APIHelper().getRequest(
        endPoint: '${EndPoints.owners}/$id/graph',
        queryParameters: {
          'resource': resource,
          'filter': filter,
        },
      );
      return response;
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }
}
