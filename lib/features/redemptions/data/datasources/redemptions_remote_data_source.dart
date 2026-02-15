import '../../../../core/network/api_helper.dart';
import '../../../../core/network/api_endpoiont.dart';
import '../../../../core/network/api_response.dart';

class RedemptionsRemoteDataSource {
  Future<ApiResponse> getRedemptions({
    String? status,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final Map<String, dynamic> queryParameters = {
        'page': page,
        'limit': limit,
      };
      if (status != null && status.isNotEmpty && status != 'Pending') {
        if (status != 'All') {
          queryParameters['status'] = status.toUpperCase();
        }

        final response = await APIHelper().getRequest(
          endPoint: EndPoints.redemptions,
          queryParameters: queryParameters,
        );
        return response;
      } else {
        // For Pending status (default or explicit), use the pending endpoint
        // Check if pending endpoint supports pagination (usually yes)
        // If EndPoints.redemptionsPending is a specific path, we append query params
        final response = await APIHelper().getRequest(
          endPoint: EndPoints.redemptionsPending,
          queryParameters: queryParameters,
        );
        return response;
      }
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  Future<ApiResponse> getPendingRedemptions() async {
    try {
      final response = await APIHelper().getRequest(
        endPoint: EndPoints.redemptionsPending,
      );
      return response;
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  Future<ApiResponse> processRedemption(
      String id, String action, String note) async {
    try {
      final response = await APIHelper().postRequest(
        endPoint: EndPoints.redemptionsProcess,
        data: {
          'reqId': id,
          'action': action,
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
