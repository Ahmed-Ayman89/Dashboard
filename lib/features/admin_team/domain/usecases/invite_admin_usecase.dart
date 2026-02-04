import '../../../../core/network/api_response.dart';
import '../../data/models/invite_admin_request_model.dart';
import '../../domain/repositories/admin_team_repository.dart';

class InviteAdminUseCase {
  final AdminTeamRepository _repository;

  InviteAdminUseCase(this._repository);

  Future<ApiResponse> call(InviteAdminRequestModel request) async {
    return await _repository.inviteAdmin(request);
  }
}
