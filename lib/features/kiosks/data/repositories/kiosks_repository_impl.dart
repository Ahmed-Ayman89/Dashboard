import '../../../../core/network/api_response.dart';
import '../../data/datasources/kiosks_remote_data_source.dart';
import '../../domain/repositories/kiosks_repository.dart';

class KiosksRepositoryImpl implements KiosksRepository {
  final KiosksRemoteDataSource _remoteDataSource = KiosksRemoteDataSource();

  @override
  Future<ApiResponse> getKiosks({int page = 1, int limit = 10}) async {
    try {
      return await _remoteDataSource.getKiosks(page: page, limit: limit);
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  @override
  Future<ApiResponse> getKioskDetails(String id) async {
    try {
      return await _remoteDataSource.getKioskDetails(id);
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  @override
  Future<ApiResponse> updateKiosk(String id, Map<String, dynamic> data) async {
    try {
      return await _remoteDataSource.updateKiosk(id, data);
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  @override
  Future<ApiResponse> changeKioskStatus(
      String id, bool isActive, String? reason) async {
    try {
      return await _remoteDataSource.changeKioskStatus(id, isActive, reason);
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  @override
  Future<ApiResponse> adjustKioskDues(
      String id, double amount, String reason) async {
    try {
      return await _remoteDataSource.adjustKioskDues(id, amount, reason);
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  @override
  Future<ApiResponse> getKioskDuesDetails(String id) async {
    try {
      return await _remoteDataSource.getKioskDuesDetails(id);
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  @override
  Future<ApiResponse> getKioskGraph({
    required String id,
    String resource = 'commission_earned',
    String filter = '7d',
  }) async {
    try {
      return await _remoteDataSource.getKioskGraph(
        id: id,
        resource: resource,
        filter: filter,
      );
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }
}
