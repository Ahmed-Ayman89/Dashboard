import '../../../../core/network/api_helper.dart';
import '../../../../core/network/api_endpoiont.dart';
import '../../../../core/network/api_response.dart';

class AdminRemoteDataSource {
  Future<ApiResponse> getAdmins({int page = 1, int limit = 10}) async {
    try {
      final response = await APIHelper().getRequest(
        endPoint: EndPoints.adminTeam,
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

  Future<ApiResponse> createAdmin(Map<String, dynamic> data) async {
    try {
      final response = await APIHelper().postRequest(
        endPoint: EndPoints.adminTeam,
        data: data,
        isFormData: false,
      );
      return response;
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }
}
