import '../../../../core/network/api_helper.dart';
import '../../../../core/network/api_endpoiont.dart';
import '../../../../core/network/api_response.dart';

class KiosksRemoteDataSource {
  Future<ApiResponse> getKiosks({int page = 1, int limit = 10}) async {
    try {
      final response = await APIHelper().getRequest(
        endPoint: EndPoints.adminKiosks,
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

  Future<ApiResponse> getKioskDetails(String id) async {
    try {
      final response = await APIHelper().getRequest(
        endPoint: '${EndPoints.adminKiosks}/$id',
      );
      return response;
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  Future<ApiResponse> updateKiosk(String id, Map<String, dynamic> data) async {
    try {
      final response = await APIHelper().putRequest(
        endPoint: '${EndPoints.adminKiosks}/$id',
        data: data,
        isFormData: false,
      );
      return response;
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  Future<ApiResponse> changeKioskStatus(
      String id, bool isActive, String? reason) async {
    try {
      final response = await APIHelper().putRequest(
        endPoint: '${EndPoints.adminKiosks}/$id/status',
        data: {
          'is_active': isActive,
          'reason': reason ?? '',
        },
        isFormData: false,
      );
      return response;
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  Future<ApiResponse> adjustKioskDues(
      String id, double amount, String reason) async {
    try {
      final response = await APIHelper().postRequest(
        endPoint: '${EndPoints.adminKiosks}/$id/dues',
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

  Future<ApiResponse> getKioskDuesDetails(String id) async {
    try {
      final response = await APIHelper().getRequest(
        endPoint: '${EndPoints.adminKiosks}/$id/dues-details',
      );
      return response;
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }
}
