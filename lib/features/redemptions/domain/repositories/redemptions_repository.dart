import '../../../../core/network/api_response.dart';

abstract class RedemptionsRepository {
  Future<ApiResponse> getRedemptions({String? status, int page, int limit});
  Future<ApiResponse> getPendingRedemptions();
  Future<ApiResponse> processRedemption(String id, String action, String note);
}
