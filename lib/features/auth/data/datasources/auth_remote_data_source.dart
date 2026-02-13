import '../../../../core/network/api_endpoiont.dart';
import '../../../../core/network/api_helper.dart';
import '../../../../core/network/api_response.dart';
import '../models/login_request_model.dart';

class AuthRemoteDataSource {
  final APIHelper _apiHelper = APIHelper();

  Future<ApiResponse> login(LoginRequestModel loginRequest) async {
    final jsonData = loginRequest.toJson();
    print('Login Request JSON: $jsonData'); // Debug print
    return await _apiHelper.postRequest(
      endPoint: EndPoints.login,
      data: jsonData,
      isAuthorized: false, // Login usually doesn't need token
      isFormData: false,
    );
  }

  Future<ApiResponse> deleteFcmToken(String token) async {
    print('AuthRemoteDataSource: Deleting FCM token: $token');
    final response = await _apiHelper.deleteRequest(
      endPoint: EndPoints.fcmToken,
      data: {'token': token},
      isAuthorized: true,
      isFormData: false,
    );
    print(
        'AuthRemoteDataSource: deleteFcmToken response status: ${response.statusCode}');
    return response;
  }

  Future<ApiResponse> setPassword(String password) async {
    return await _apiHelper.postRequest(
      endPoint: EndPoints.adminSetPassword,
      data: {'password': password},
      isAuthorized: true,
      isFormData: false,
    );
  }

  Future<ApiResponse> verifyToken() async {
    return await _apiHelper.getRequest(
      endPoint: EndPoints.verify,
      isProtected: true,
    );
  }
}
