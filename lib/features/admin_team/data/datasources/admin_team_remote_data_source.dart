import '../../../../core/network/api_endpoiont.dart';
import '../../../../core/network/api_helper.dart';
import '../../../../core/network/api_response.dart';
import '../models/invite_admin_request_model.dart';

class AdminTeamRemoteDataSource {
  final APIHelper _apiHelper = APIHelper();

  Future<ApiResponse> inviteAdmin(InviteAdminRequestModel request) async {
    return await _apiHelper.postRequest(
      endPoint: EndPoints.inviteAdmin,
      data: request.toJson(),
      isAuthorized: true, // Requires admin token
      isFormData: false, // Ensure JSON format
    );
  }
}
