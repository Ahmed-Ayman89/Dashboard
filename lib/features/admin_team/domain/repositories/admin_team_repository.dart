import '../../../../core/network/api_response.dart';
import '../../data/models/invite_admin_request_model.dart';

abstract class AdminTeamRepository {
  Future<ApiResponse> inviteAdmin(InviteAdminRequestModel request);
}
