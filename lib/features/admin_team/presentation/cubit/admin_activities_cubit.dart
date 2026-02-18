import 'package:dashboard_grow/features/admin_team/data/models/admin_activity_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_admin_activities_usecase.dart';
import 'admin_activities_state.dart';

class AdminActivitiesCubit extends Cubit<AdminActivitiesState> {
  final GetAdminActivitiesUseCase _getAdminActivitiesUseCase;

  AdminActivitiesCubit(this._getAdminActivitiesUseCase)
      : super(AdminActivitiesInitial());

  Future<void> getActivities(String adminId,
      {int page = 1, int limit = 20}) async {
    emit(AdminActivitiesLoading());
    try {
      final response =
          await _getAdminActivitiesUseCase(adminId, page: page, limit: limit);
      if (isClosed) return;

      if (response.isSuccess && response.data != null) {
        final Map<String, dynamic> responseData = response.data;

        final Map<String, dynamic> innerData = responseData.containsKey('data')
            ? responseData['data']
            : responseData;

        final List<dynamic> activitiesList =
            innerData['activities'] as List? ?? [];
        final int total = innerData['total'] ?? 0;
        final int currentPage = innerData['page'] ?? 1;
        final int currentLimit = innerData['limit'] ?? 20;

        final List<AdminActivity> activities = activitiesList
            .map((e) => AdminActivity.fromJson(e as Map<String, dynamic>))
            .toList();

        emit(AdminActivitiesLoaded(
          activities: activities,
          total: total,
          page: currentPage,
          limit: currentLimit,
        ));
      } else {
        emit(AdminActivitiesFailure(
            response.message ?? 'Failed to load activities'));
      }
    } catch (e) {
      if (isClosed) return;
      emit(AdminActivitiesFailure(e.toString()));
    }
  }
}
