import 'package:flutter_bloc/flutter_bloc.dart';
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
      (failure) => emit(DashboardStatsError(failure.message)),
      (stats) => emit(DashboardStatsSuccess(stats)),
    );
  }
}
