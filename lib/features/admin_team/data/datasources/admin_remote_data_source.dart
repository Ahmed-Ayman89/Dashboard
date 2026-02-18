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

  Future<ApiResponse> getAdminActivities(String id,
      {int page = 1, int limit = 20}) async {
    try {
      final response = await APIHelper().getRequest(
        endPoint: '${EndPoints.adminTeam}/$id/activities',
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

  Future<ApiResponse> updateAdmin(String id, Map<String, dynamic> data) async {
    try {
      final response = await APIHelper().putRequest(
        endPoint: '${EndPoints.adminTeam}/$id',
        data: data,
        isFormData: false,
      );
      return response;
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  Future<ApiResponse> deleteAdmin(String id) async {
    try {
      final response = await APIHelper().deleteRequest(
        endPoint: '${EndPoints.adminTeam}/$id',
      );
      return response;
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }
}
