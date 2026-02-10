import '../../../../core/network/api_helper.dart';
import '../../../../core/network/api_endpoiont.dart';
import '../../../../core/network/api_response.dart';

class RedemptionsRemoteDataSource {
  Future<ApiResponse> getRedemptions({String? status}) async {
    try {
      final Map<String, dynamic> queryParameters = {};
      if (status != null && status.isNotEmpty && status != 'Pending') {
        // If generic endpoint used, pass status.
        // But wait, if status is 'Pending', we use redemptionsPending endpoint?
        // Or we use generic endpoint for everything?
        // Let's assume generic endpoint 'admin/redemptions' works for all if we pass status.
        // But to be safe and backward compatible, let's keep getPendingRedemptions logic or mix it.

        // If status is PENDING, we could use the specific pending endpoint if the generic one doesn't default to it.
        // However, cleaner to use generic if possible.
        // Let's try to use generic for everything if 'status' is provided.

        if (status != 'All') {
          queryParameters['status'] = status.toUpperCase();
        }

        final response = await APIHelper().getRequest(
          endPoint: EndPoints.redemptions,
          queryParameters: queryParameters,
        );
        return response;
      } else {
        // Default to pending if no status or status is Pending
        // Actually, if status is 'Pending', we should probably use the pending endpoint if we are sure about it.
        // But let's assume 'admin/redemptions?status=PENDING' is valid too.
        // To be safe, I'll use Pending endpoint for Pending status, and generic for others.

        return await getPendingRedemptions();
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
