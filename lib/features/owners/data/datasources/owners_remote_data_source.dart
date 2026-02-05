import '../../../../core/network/api_helper.dart';
import '../../../../core/network/api_endpoiont.dart';
import '../../../../core/network/api_response.dart';

class OwnersRemoteDataSource {
  Future<ApiResponse> getOwners({
    int page = 1,
    int limit = 10,
    String search = '',
  }) async {
    try {
      final response = await APIHelper().getRequest(
        endPoint: EndPoints
            .owners, // Assuming this endpoint exists in APIHelper/EndPoints or needs to be added
        queryParameters: {
          'page': page,
          'limit': limit,
          'search': search,
        },
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
}
