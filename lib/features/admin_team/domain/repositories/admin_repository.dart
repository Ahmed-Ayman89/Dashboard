import '../../../../core/network/api_response.dart';

abstract class AdminRepository {
  Future<ApiResponse> getAdmins();
  Future<ApiResponse> createAdmin(Map<String, dynamic> data);
}
