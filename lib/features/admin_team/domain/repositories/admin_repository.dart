import '../../../../core/network/api_response.dart';

abstract class AdminRepository {
  Future<ApiResponse> getAdmins({int page = 1, int limit = 10});
  Future<ApiResponse> createAdmin(Map<String, dynamic> data);
}
