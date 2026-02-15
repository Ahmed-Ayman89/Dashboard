import 'package:bloc/bloc.dart';
import 'package:dashboard_grow/features/dues/data/models/dues_dashboard_model.dart';
import 'package:dashboard_grow/features/dues/domain/entities/due.dart';
import 'package:dashboard_grow/features/dues/domain/usecases/collect_due_usecase.dart';
import 'package:dashboard_grow/features/dues/domain/usecases/get_dues_dashboard_usecase.dart';
import 'package:dashboard_grow/features/dues/domain/usecases/get_dues_usecase.dart';
import 'package:equatable/equatable.dart';

part 'dues_state.dart';

class DuesCubit extends Cubit<DuesState> {
  final GetDuesUseCase getDuesUseCase;
  final CollectDueUseCase collectDueUseCase;
  final GetDuesDashboardUseCase getDuesDashboardUseCase;

  DuesCubit({
    required this.getDuesUseCase,
    required this.collectDueUseCase,
    required this.getDuesDashboardUseCase,
  }) : super(DuesInitial());

  Future<void> getDues({int page = 1, int limit = 10}) async {
    emit(DuesLoading());
    final duesResult = await getDuesUseCase(page: page, limit: limit);
    final dashboardResult = await getDuesDashboardUseCase();

    if (isClosed) return;

    duesResult.fold(
      (failure) => emit(DuesError(message: failure.message)),
      (dueResponse) {
        dashboardResult.fold(
          (failure) => emit(DuesLoaded(
            dues: dueResponse.dueList,
            total: dueResponse.total,
            page: dueResponse.page,
            limit: dueResponse.limit,
          )), // Still show dues if dashboard fails
          (dashboard) => emit(DuesLoaded(
            dues: dueResponse.dueList,
            dashboardData: dashboard,
            total: dueResponse.total,
            page: dueResponse.page,
            limit: dueResponse.limit,
          )),
        );
      },
    );
  }

  void changePage(int page) {
    if (state is DuesLoaded) {
      final currentState = state as DuesLoaded;
      getDues(page: page, limit: currentState.limit);
    }
  }

  Future<void> collectDue(String dueId, double amount) async {
    emit(DuesActionLoading());
    final result = await collectDueUseCase(dueId, amount);
    if (isClosed) return;
    result.fold(
      (failure) => emit(DuesError(message: failure.message)),
      (success) {
        emit(DuesActionSuccess(message: success));
        getDues();
      },
    );
  }
}
