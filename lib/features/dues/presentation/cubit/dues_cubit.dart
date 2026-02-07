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

  Future<void> getDues() async {
    emit(DuesLoading());
    final duesResult = await getDuesUseCase();
    final dashboardResult = await getDuesDashboardUseCase();

    if (isClosed) return;

    duesResult.fold(
      (failure) => emit(DuesError(message: failure.message)),
      (dues) {
        dashboardResult.fold(
          (failure) => emit(
              DuesLoaded(dues: dues)), // Still show dues if dashboard fails
          (dashboard) => emit(DuesLoaded(dues: dues, dashboardData: dashboard)),
        );
      },
    );
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
