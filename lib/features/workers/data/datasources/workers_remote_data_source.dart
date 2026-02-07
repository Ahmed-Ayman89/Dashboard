import '../../../../core/network/api_helper.dart';
import '../../../../core/network/api_endpoiont.dart';
import '../../../../core/network/api_response.dart';

class WorkersRemoteDataSource {
  Future<ApiResponse> getWorkers({
    int page = 1,
    int limit = 10,
    String? search,
  }) async {
    final Map<String, dynamic> queryParameters = {
      'page': page,
      'limit': limit,
    };
    if (search != null && search.isNotEmpty) {
      queryParameters['search'] = search;
    }

    try {
      final response = await APIHelper().getRequest(
        endPoint: EndPoints.workers,
        queryParameters: queryParameters,
      );
      return response;
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  Future<ApiResponse> getWorkerDetails(String id) async {
    try {
      final response = await APIHelper().getRequest(
        endPoint: '${EndPoints.workers}/$id',
      );
      return response;
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  Future<ApiResponse> deleteWorker(
      String id, String kioskId, String profileId) async {
    try {
      final response = await APIHelper().deleteRequest(
        endPoint: '${EndPoints.workers}/$id/profile',
        data: {
          'kioskId': kioskId,
          'profileId': profileId,
        },
      );
      return response;
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  Future<ApiResponse> banWorker(String id) async {
    try {
      final response = await APIHelper().deleteRequest(
        endPoint: '${EndPoints.workers}/$id',
        data: {}, // Assuming no body is needed or empty body for ban, verifying usage
      );
      return response;
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  Future<ApiResponse> getWorkerGraph({
    required String id,
    String resource = 'transactions_amount',
    String filter = 'weekly',
  }) async {
    try {
      final response = await APIHelper().getRequest(
        endPoint: '${EndPoints.workers}/$id/graph',
        queryParameters: {
          'resource': resource,
          'filter': filter,
        },
      );
      return response;
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }
}
