import '../../../../core/network/api_helper.dart';
import '../../../../core/network/api_endpoiont.dart';
import '../../../../core/network/api_response.dart';

class DashboardRemoteDataSource {
  Future<ApiResponse> getAuditLogs({int page = 1, int limit = 20}) async {
    try {
      final response = await APIHelper().getRequest(
        endPoint: EndPoints.auditLogs,
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

  Future<ApiResponse> getGraphData({
    required String filter,
    required String resource,
    String? from,
    String? to,
  }) async {
    try {
      final queryParams = {
        'filter': filter,
        'resource': resource,
        if (from != null) 'from': from,
        if (to != null) 'to': to,
      };

      final response = await APIHelper().getRequest(
        endPoint: EndPoints.dashboardGraph,
        queryParameters: queryParams,
      );
      return response;
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  Future<ApiResponse> getDashboardStats() async {
    try {
      final response = await APIHelper().getRequest(
        endPoint: EndPoints.dashboard,
      );
      return response;
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }
}
