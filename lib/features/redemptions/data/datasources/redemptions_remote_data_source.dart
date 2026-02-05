import '../../../../core/network/api_helper.dart';
import '../../../../core/network/api_endpoiont.dart';
import '../../../../core/network/api_response.dart';

class RedemptionsRemoteDataSource {
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
