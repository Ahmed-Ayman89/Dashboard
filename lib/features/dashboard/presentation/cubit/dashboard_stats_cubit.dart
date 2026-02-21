import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/get_dashboard_stats_usecase.dart';
import 'dashboard_stats_state.dart';

class DashboardStatsCubit extends Cubit<DashboardStatsState> {
  final GetDashboardStatsUseCase getDashboardStatsUseCase;

  DashboardStatsCubit(this.getDashboardStatsUseCase)
      : super(DashboardStatsInitial());

  Future<void> loadDashboardStats() async {
    emit(DashboardStatsLoading());

    final result = await getDashboardStatsUseCase();

    if (isClosed) return;

    result.fold(
      (failure) {
        if (failure is ServerFailure && failure.errorCode == 'AUTH_009') {
          emit(DashboardStatsPendingApproval());
        } else {
          emit(DashboardStatsError(failure.message));
        }
      },
      (stats) => emit(DashboardStatsSuccess(stats)),
    );
  }
}
