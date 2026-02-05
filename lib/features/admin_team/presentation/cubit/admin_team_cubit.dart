import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/admin_model.dart';
import '../../domain/usecases/get_admins_usecase.dart';
import '../../domain/usecases/create_admin_usecase.dart';
import 'admin_team_state.dart';

class AdminTeamCubit extends Cubit<AdminTeamState> {
  final GetAdminsUseCase _getAdminsUseCase;
  final CreateAdminUseCase _createAdminUseCase;

  AdminTeamCubit(this._getAdminsUseCase, this._createAdminUseCase)
      : super(AdminTeamInitial());

  Future<void> getAdmins() async {
    emit(AdminTeamLoading());
    try {
      final response = await _getAdminsUseCase();
      if (response.isSuccess && response.data != null) {
        final responseData = response.data;
        // Handle data wrapper if present
        final innerData = (responseData is Map<String, dynamic> &&
                responseData.containsKey('data'))
            ? responseData['data']
            : responseData;

        final List<AdminUser> admins = (innerData as List)
            .map((e) => AdminUser.fromJson(e as Map<String, dynamic>))
            .toList();

        emit(AdminTeamLoaded(admins));
      } else {
        emit(AdminTeamFailure(response.message ?? 'Failed to load admins'));
      }
    } catch (e) {
      emit(AdminTeamFailure(e.toString()));
    }
  }

  Future<void> createAdmin(CreateAdminRequest request) async {
    // We don't want to clear the list when creating, so we use a separate action state if needed,
    // but typically we just show a loading indicator on the dialog.
    // For simplicity, we can emit a loading state that doesn't wipe the view if the UI handles it,
    // or just assume the dialog handles its own loading state.
    // simpler approach:
    emit(AdminTeamActionLoading());
    try {
      final response = await _createAdminUseCase(request);
      if (response.isSuccess) {
        emit(const AdminTeamActionSuccess('Admin created successfully'));
        getAdmins(); // Refresh list to show new admin
      } else {
        emit(AdminTeamFailure(response.message ?? 'Failed to create admin'));
        // After failure, we might want to go back to Loaded state if we had data?
        // For now, failure will likely trigger a Snackbar.
      }
    } catch (e) {
      emit(AdminTeamFailure(e.toString()));
    }
  }
}
