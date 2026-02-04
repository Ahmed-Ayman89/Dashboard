import '../../../../core/network/api_response.dart';
import '../../data/datasources/admin_team_remote_data_source.dart';
import '../../data/models/invite_admin_request_model.dart';
import '../../domain/repositories/admin_team_repository.dart';

class AdminTeamRepositoryImpl implements AdminTeamRepository {
  final AdminTeamRemoteDataSource _remoteDataSource =
      AdminTeamRemoteDataSource();

  @override
  Future<ApiResponse> inviteAdmin(InviteAdminRequestModel request) async {
    return await _remoteDataSource.inviteAdmin(request);
  }
}
