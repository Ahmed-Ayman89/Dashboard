import '../../../../core/network/api_response.dart';
import '../../data/datasources/admin_remote_data_source.dart';
import '../../domain/repositories/admin_repository.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource _remoteDataSource = AdminRemoteDataSource();

  @override
  Future<ApiResponse> getAdmins({int page = 1, int limit = 10}) async {
    try {
      return await _remoteDataSource.getAdmins(page: page, limit: limit);
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  @override
  Future<ApiResponse> createAdmin(Map<String, dynamic> data) async {
    try {
      return await _remoteDataSource.createAdmin(data);
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }
}
