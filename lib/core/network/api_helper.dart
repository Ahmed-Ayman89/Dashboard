// ignore_for_file: unnecessary_import
import 'package:dio/dio.dart';
import 'api_endpoiont.dart';
import 'api_response.dart';
import 'local_data.dart';

class APIHelper {
  static final APIHelper _apiHelper = APIHelper._internal();
  static bool _isInitialized = false;
  static late Dio _dioInstance;

  factory APIHelper() {
    if (!_isInitialized) {
      throw Exception(
          "APIHelper not initialized. Call APIHelper.init() first in your main.dart.");
    }
    return _apiHelper;
  }

  APIHelper._internal();

  static Future<void> init() async {
    if (_isInitialized) return;

    _dioInstance = Dio(BaseOptions(
      baseUrl: EndPoints.baseUrl,
      connectTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    ));

    _dioInstance.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: false,
      responseBody: true,
      error: true,
    ));

    _dioInstance.interceptors.add(
      QueuedInterceptorsWrapper(
        onError: (DioException err, handler) async {
          if (err.response?.statusCode == 401) {
            if (err.requestOptions.path.contains(EndPoints.refreshToken)) {
              await LocalData.clear();
              return handler.reject(err);
            }

            // Don't clear tokens for wrong passcode scenarios
            if (err.requestOptions.path
                    .contains(EndPoints.customerLoginComplete) ||
                err.requestOptions.path
                    .contains(EndPoints.customerRegisterComplete)) {
              return handler.next(err);
            }

            try {
              final refreshToken = LocalData.refreshToken;
              if (refreshToken == null || refreshToken.isEmpty) {
                await LocalData.clear();
                return handler.reject(err);
              }

              // Create a new Dio instance for the token request to avoid infinite loops with interceptors
              final refreshDio = Dio(BaseOptions(baseUrl: EndPoints.baseUrl));

              final refreshResponse = await refreshDio.post(
                EndPoints.refreshToken,
                data: {'refreshToken': refreshToken},
                options: Options(
                  headers: {'Content-Type': 'application/json'},
                ),
              );

              if (refreshResponse.statusCode == 200 &&
                  refreshResponse.data['success'] == true &&
                  refreshResponse.data['data'] != null &&
                  refreshResponse.data['data']['accessToken'] != null) {
                final newAccessToken =
                    refreshResponse.data['data']['accessToken'];
                final newRefreshToken =
                    refreshResponse.data['data']['refreshToken'];

                await LocalData.saveTokens(
                  accessToken: newAccessToken,
                  refreshToken: newRefreshToken ?? refreshToken,
                );

                // Update token in original request and retry
                err.requestOptions.headers['Authorization'] =
                    'Bearer $newAccessToken';

                final retryResponse =
                    await _dioInstance.fetch(err.requestOptions);
                return handler.resolve(retryResponse);
              } else {
                await LocalData.clear();
                return handler.reject(err);
              }
            } catch (refreshError) {
              await LocalData.clear();
              return handler.reject(err);
            }
          }
          return handler.next(err);
        },
      ),
    );

    _isInitialized = true;
  }

  Dio get dio => _dioInstance;

  Future<ApiResponse> _handleRequest(
    Future<Response> Function() request, {
    required bool isProtected,
  }) async {
    if (isProtected) {
      final token = LocalData.accessToken;
      if (token == null || token.isEmpty) {
        return ApiResponse.error(
          statusCode: 401,
          message: 'No access token found for protected route',
        );
      }
    }

    try {
      final response = await request();
      final apiResponse = ApiResponse.fromResponse(response);
      return apiResponse;
    } catch (e) {
      final apiResponse = ApiResponse.fromError(e);
      return apiResponse;
    }
  }

  Future<ApiResponse> getRequest({
    required String endPoint,
    String? resourcePath,
    Map<String, dynamic>? queryParameters,
    bool isProtected = true,
  }) async {
    return _handleRequest(isProtected: isProtected, () async {
      final finalEndpoint = resourcePath != null && resourcePath.isNotEmpty
          ? '$endPoint/$resourcePath'
          : endPoint;

      String? token;
      if (isProtected) {
        token = LocalData.accessToken;
      }

      return dio.get(
        finalEndpoint,
        queryParameters: queryParameters,
        options: Options(headers: {
          if (isProtected && token != null) "Authorization": "Bearer $token",
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }),
      );
    });
  }

  Future<ApiResponse> postRequest({
    required String endPoint,
    Map<String, dynamic>? data,
    bool isFormData = true,
    bool isAuthorized = true,
    Map<String, String>? extraHeaders,
  }) async {
    return _handleRequest(isProtected: isAuthorized, () async {
      String? token;
      if (isAuthorized) {
        token = LocalData.accessToken;
      }

      final headers = {
        if (isAuthorized && token != null) "Authorization": "Bearer $token",
        'Content-Type': isFormData ? 'multipart/form-data' : 'application/json',
        if (extraHeaders != null) ...extraHeaders,
      };

      return dio.post(
        endPoint,
        data: isFormData && data != null ? FormData.fromMap(data) : data,
        options: Options(headers: headers),
      );
    });
  }

  Future<ApiResponse> putRequest({
    required String endPoint,
    Map<String, dynamic>? data,
    bool isFormData = true,
    bool isAuthorized = true,
  }) async {
    return _handleRequest(isProtected: isAuthorized, () async {
      String? token;
      if (isAuthorized) {
        token = LocalData.accessToken;
      }
      return dio.put(
        endPoint,
        data: isFormData ? FormData.fromMap(data ?? {}) : data,
        options: Options(headers: {
          if (isAuthorized && token != null) "Authorization": "Bearer $token",
          'Content-Type':
              isFormData ? 'multipart/form-data' : 'application/json',
        }),
      );
    });
  }

  Future<ApiResponse> patchRequest({
    required String endPoint,
    Map<String, dynamic>? data,
    bool isFormData = false,
    bool isAuthorized = true,
  }) async {
    return _handleRequest(isProtected: isAuthorized, () async {
      // LogInterceptor handles logging automatically
      String? token;
      if (isAuthorized) {
        token = LocalData.accessToken;
      }
      return dio.patch(
        endPoint,
        data: isFormData && data != null ? FormData.fromMap(data) : data,
        options: Options(headers: {
          if (isAuthorized && token != null) "Authorization": "Bearer $token",
          'Content-Type':
              isFormData ? 'multipart/form-data' : 'application/json',
        }),
      );
    });
  }

  Future<ApiResponse> deleteRequest({
    required String endPoint,
    Map<String, dynamic>? data,
    bool isFormData = false,
    bool isAuthorized = true,
  }) async {
    return _handleRequest(
      isProtected: isAuthorized,
      () async {
        String? token;
        if (isAuthorized) {
          token = LocalData.accessToken;
        }
        return dio.delete(
          endPoint,
          data: isFormData && data != null ? FormData.fromMap(data) : data,
          options: Options(headers: {
            if (isAuthorized && token != null) "Authorization": "Bearer $token",
            'Content-Type':
                isFormData ? 'multipart/form-data' : 'application/json',
          }),
        );
      },
    );
  }
}
