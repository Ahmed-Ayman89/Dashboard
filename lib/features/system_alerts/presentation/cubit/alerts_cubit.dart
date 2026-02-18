import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard_grow/features/system_alerts/domain/usecases/get_system_alerts_usecase.dart';
import 'package:dashboard_grow/features/system_alerts/presentation/cubit/alerts_state.dart';

class AlertsCubit extends Cubit<AlertsState> {
  final GetSystemAlertsUseCase getSystemAlertsUseCase;

  AlertsCubit(this.getSystemAlertsUseCase) : super(AlertsInitial());

  Future<void> getAlerts({int page = 1, int limit = 10}) async {
    if (state is AlertsLoading || state is AlertsFetchingMore) return;

    if (page == 1) {
      emit(AlertsLoading());
    } else {
      if (state is AlertsLoaded) {
        final currentState = state as AlertsLoaded;
        emit(AlertsFetchingMore(
          alerts: currentState.alerts,
          pagination: currentState.pagination,
        ));
      }
    }

    final result = await getSystemAlertsUseCase(page: page, limit: limit);

    result.fold(
      (failure) => emit(AlertsFailure(failure.message)),
      (response) {
        if (page == 1) {
          emit(AlertsLoaded(
            alerts: response.alerts,
            pagination: response.pagination,
          ));
        } else {
          final currentState = state as AlertsLoaded;
          emit(AlertsLoaded(
            alerts: [...currentState.alerts, ...response.alerts],
            pagination: response.pagination,
          ));
        }
      },
    );
  }
}
