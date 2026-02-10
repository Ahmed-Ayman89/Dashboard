import 'package:dashboard_grow/core/network/api_response.dart';

abstract class CallsRepository {
  Future<ApiResponse> getCalls({int page = 1, int limit = 10});
  Future<ApiResponse> getCallDetails(String id);
  Future<ApiResponse> updateCallStatus(String id, String status);
}
