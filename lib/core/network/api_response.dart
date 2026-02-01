import 'package:dio/dio.dart';

enum ApiStatus { success, error }

class ApiResponse<T> {
  final ApiStatus status;
  final int? statusCode;
  final T? data;
  final String? message;
  final ApiError? error;

  const ApiResponse._({
    required this.status,
    this.statusCode,
    this.data,
    this.message,
    this.error,
  });

  bool get isSuccess => status == ApiStatus.success;

  // Success factory
  factory ApiResponse.success({
    required T data,
    int? statusCode,
    String? message,
  }) {
    return ApiResponse._(
      status: ApiStatus.success,
      data: data,
      statusCode: statusCode,
      message: message,
    );
  }

  /// Error factory
  factory ApiResponse.error({
    int? statusCode,
    String? message,
    ApiError? error,
  }) {
    return ApiResponse._(
      status: ApiStatus.error,
      statusCode: statusCode,
      message: message,
      error: error,
    );
  }

  /// Build ApiResponse from Dio Response
  static ApiResponse<T> fromResponse<T>(
    Response response, {
    T Function(dynamic json)? parser,
  }) {
    final code = response.statusCode;
    final body = response.data;

    if (code != null && code >= 200 && code < 300) {
      return ApiResponse.success(
        data: parser != null ? parser(body) : body as T,
        statusCode: code,
        message: _extractMessage(body),
      );
    }

    return ApiResponse.error(
      statusCode: code,
      message: _extractMessage(body) ?? response.statusMessage,
      error: ApiError.server(code, _extractMessage(body)),
    );
  }

  /// Build ApiResponse from DioException
  static ApiResponse<T> fromDioException<T>(DioException e) {
    final response = e.response;
    final code = response?.statusCode;

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiResponse.error(
          statusCode: code,
          message: 'Request timeout',
          error: ApiError.timeout(),
        );

      case DioExceptionType.badResponse:
        return ApiResponse.error(
          statusCode: code,
          message: _extractMessage(response?.data) ?? 'Server error',
          error: ApiError.server(code, _extractMessage(response?.data)),
        );

      case DioExceptionType.cancel:
        return ApiResponse.error(
          statusCode: code,
          message: 'Request cancelled',
          error: ApiError.cancelled(),
        );

      case DioExceptionType.connectionError:
        return ApiResponse.error(
          statusCode: code,
          message: 'No internet connection',
          error: ApiError.network(),
        );

      case DioExceptionType.unknown:
      default:
        return ApiResponse.error(
          statusCode: code,
          message: 'Unexpected error',
          error: ApiError.unknown(e.message),
        );
    }
  }

  static ApiResponse<T> fromError<T>(dynamic e) {
    if (e is DioException) {
      return fromDioException(e);
    }
    return ApiResponse.error(
      message: e.toString(),
      error: ApiError.unknown(e.toString()),
    );
  }

  static String? _extractMessage(dynamic body) {
    if (body is Map<String, dynamic>) {
      return body['message']?.toString();
    }
    return null;
  }
}

/// Structured error model
class ApiError {
  final String type;
  final String? details;
  final int? statusCode;

  const ApiError._(this.type, {this.details, this.statusCode});

  factory ApiError.network() => const ApiError._('network');

  factory ApiError.timeout() => const ApiError._('timeout');

  factory ApiError.cancelled() => const ApiError._('cancelled');

  factory ApiError.server(int? code, String? details) => ApiError._(
        'server',
        statusCode: code,
        details: details,
      );

  factory ApiError.unknown(String? details) => ApiError._(
        'unknown',
        details: details,
      );
}
