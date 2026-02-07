import '../../../../core/network/api_response.dart';
import '../../domain/repositories/owners_repository.dart';
import '../datasources/owners_remote_data_source.dart';

class OwnersRepositoryImpl implements OwnersRepository {
  final OwnersRemoteDataSource _remoteDataSource = OwnersRemoteDataSource();

  @override
  Future<ApiResponse> getOwners({
    int page = 1,
    int limit = 10,
    String search = '',
  }) async {
    try {
      return await _remoteDataSource.getOwners(
        page: page,
        limit: limit,
        search: search,
      );
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  @override
  Future<ApiResponse> getOwnerDetails(String id) async {
    try {
      return await _remoteDataSource.getOwnerDetails(id);
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  @override
  Future<ApiResponse> performAction({
    required String id,
    required String action,
    required String reason,
  }) async {
    try {
      return await _remoteDataSource.performAction(
        id: id,
        action: action,
        reason: reason,
      );
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  @override
  Future<ApiResponse> getOwnerGraph({
    required String id,
    String resource = 'transactions_amount',
    String filter = 'weekly',
  }) async {
    try {
      return await _remoteDataSource.getOwnerGraph(
        id: id,
        resource: resource,
        filter: filter,
      );
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }
}
