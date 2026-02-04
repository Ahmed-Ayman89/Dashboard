import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/invite_admin_request_model.dart';
import '../../domain/usecases/invite_admin_usecase.dart';
import 'admin_team_state.dart';

class AdminTeamCubit extends Cubit<AdminTeamState> {
  final InviteAdminUseCase _inviteAdminUseCase;

  AdminTeamCubit(this._inviteAdminUseCase) : super(AdminTeamInitial());

  Future<void> inviteAdmin({
    required String phone,
    required String fullName,
    required String adminRole,
  }) async {
    emit(AdminTeamLoading());

    try {
      final request = InviteAdminRequestModel(
        phone: phone,
        fullName: fullName,
        adminRole: adminRole,
      );

      final response = await _inviteAdminUseCase(request);

      if (response.isSuccess) {
        emit(
            AdminTeamSuccess(response.message ?? 'Admin invited successfully'));
      } else {
        emit(AdminTeamFailure(response.message ?? 'Failed to invite admin'));
      }
    } catch (e) {
      emit(AdminTeamFailure(e.toString()));
    }
  }
}
