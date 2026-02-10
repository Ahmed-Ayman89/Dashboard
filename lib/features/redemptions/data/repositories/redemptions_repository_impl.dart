import '../../../../core/network/api_response.dart';
import '../../domain/repositories/redemptions_repository.dart';
import '../datasources/redemptions_remote_data_source.dart';

class RedemptionsRepositoryImpl implements RedemptionsRepository {
  final RedemptionsRemoteDataSource _remoteDataSource =
      RedemptionsRemoteDataSource();

  @override
  Future<ApiResponse> getRedemptions({String? status}) async {
    try {
      return await _remoteDataSource.getRedemptions(status: status);
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  @override
  Future<ApiResponse> getPendingRedemptions() async {
    try {
      return await _remoteDataSource.getPendingRedemptions();
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  @override
  Future<ApiResponse> processRedemption(
      String id, String action, String note) async {
    try {
      return await _remoteDataSource.processRedemption(id, action, note);
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }
}
