import 'package:dashboard_grow/core/network/api_response.dart';

abstract class CallsRepository {
  Future<ApiResponse> getCalls({
    int page = 1,
    int limit = 10,
    String? status,
    String? search,
    String? from,
    String? to,
  });
  Future<ApiResponse> getCallDetails(String id);
  Future<ApiResponse> updateCallStatus(String id, String status);
}
