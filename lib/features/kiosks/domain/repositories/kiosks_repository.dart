import '../../../../core/network/api_response.dart';

abstract class KiosksRepository {
  Future<ApiResponse> getKiosks({int page = 1, int limit = 10});
  Future<ApiResponse> getKioskDetails(String id);
  Future<ApiResponse> updateKiosk(String id, Map<String, dynamic> data);
  Future<ApiResponse> changeKioskStatus(
      String id, bool isActive, String? reason);
  Future<ApiResponse> adjustKioskDues(String id, double amount, String reason);
  Future<ApiResponse> getKioskDuesDetails(String id);
}
