import 'package:dashboard_grow/core/network/api_endpoiont.dart';
import 'package:dashboard_grow/core/network/api_helper.dart';
import 'package:dashboard_grow/core/network/api_response.dart';
import '../../domain/repositories/calls_repository.dart';

class CallsRepositoryImpl implements CallsRepository {
  final APIHelper _apiHelper = APIHelper();

  @override
  Future<ApiResponse> getCalls({
    int page = 1,
    int limit = 10,
    String? status,
    String? search,
    String? from,
    String? to,
  }) async {
    final Map<String, dynamic> queryParameters = {
      'page': page,
      'limit': limit,
    };

    if (status != null && status.isNotEmpty && status != 'All') {
      queryParameters['status'] = status.toUpperCase();
    }

    if (search != null && search.isNotEmpty) {
      queryParameters['search'] = search;
    }

    if (from != null && from.isNotEmpty) {
      queryParameters['from'] = from;
    }

    if (to != null && to.isNotEmpty) {
      queryParameters['to'] = to;
    }

    return await _apiHelper.getRequest(
      endPoint: EndPoints.adminCalls,
      queryParameters: queryParameters,
    );
  }

  Future<ApiResponse> getCallDetails(String id) async {
    return await _apiHelper.getRequest(
      endPoint: EndPoints.adminCalls,
      resourcePath: id,
    );
  }

  @override
  Future<ApiResponse> updateCallStatus(String id, String status) async {
    return await _apiHelper.putRequest(
      endPoint: '${EndPoints.adminCalls}/$id',
      data: {'status': status},
      isFormData: false,
    );
  }
}
