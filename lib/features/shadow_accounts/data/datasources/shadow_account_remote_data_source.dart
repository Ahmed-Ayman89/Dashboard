import 'package:dashboard_grow/core/network/api_endpoiont.dart';
import 'package:dashboard_grow/core/network/api_helper.dart';
import 'package:dashboard_grow/core/network/api_response.dart';

class ShadowAccountRemoteDataSource {
  final APIHelper _apiHelper;

  ShadowAccountRemoteDataSource(this._apiHelper);

  Future<ApiResponse> getShadowAccounts({
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

    return await _apiHelper.getRequest(
      endPoint: EndPoints.shadowAccounts,
      queryParameters: queryParameters,
    );
  }

  Future<ApiResponse> getShadowAccountDetails(String phone) async {
    return await _apiHelper.getRequest(
      endPoint: '${EndPoints.shadowAccounts}/$phone',
    );
  }

  Future<ApiResponse> updateLastFollowUp(
      String phone, String lastFollowUp) async {
    return await _apiHelper.putRequest(
      endPoint: '${EndPoints.shadowAccounts}/$phone',
      isFormData: false,
      data: {
        'lastFollowUp': lastFollowUp,
      },
    );
  }
}
