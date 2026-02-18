import '../../../../core/network/api_response.dart';

abstract class AdminRepository {
  Future<ApiResponse> getAdmins({int page = 1, int limit = 10});
  Future<ApiResponse> getAdminActivities(String id,
      {int page = 1, int limit = 20});
  Future<ApiResponse> createAdmin(Map<String, dynamic> data);
  Future<ApiResponse> updateAdmin(String id, Map<String, dynamic> data);
  Future<ApiResponse> deleteAdmin(String id);
}
