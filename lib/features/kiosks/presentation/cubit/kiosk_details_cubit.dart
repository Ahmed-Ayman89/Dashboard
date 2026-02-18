import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard_grow/features/kiosks/domain/usecases/get_kiosk_details_usecase.dart';
import 'package:dashboard_grow/features/kiosks/domain/usecases/update_kiosk_usecase.dart';
import 'package:dashboard_grow/features/kiosks/domain/usecases/change_kiosk_status_usecase.dart';
import 'package:dashboard_grow/features/kiosks/domain/usecases/adjust_kiosk_dues_usecase.dart';
import 'package:dashboard_grow/features/dues/domain/usecases/collect_due_usecase.dart';
import 'package:dashboard_grow/features/dashboard/data/models/kiosk_detail_model.dart';
import 'package:dashboard_grow/features/kiosks/presentation/cubit/kiosk_details_state.dart';

class KioskDetailsCubit extends Cubit<KioskDetailsState> {
  final GetKioskDetailsUseCase _getKioskDetailsUseCase;
  final UpdateKioskUseCase _updateKioskUseCase;
  final ChangeKioskStatusUseCase _changeKioskStatusUseCase;
  final AdjustKioskDuesUseCase _adjustKioskDuesUseCase;
  final CollectDueUseCase _collectDueUseCase;

  KioskDetailsCubit(
    this._getKioskDetailsUseCase,
    this._updateKioskUseCase,
    this._changeKioskStatusUseCase,
    this._adjustKioskDuesUseCase,
    this._collectDueUseCase,
  ) : super(KioskDetailsInitial());

  Future<void> getKioskDetails(String id) async {
    emit(KioskDetailsLoading());
    try {
      final response = await _getKioskDetailsUseCase(id);

      if (isClosed) return;

      if (response.isSuccess) {
        final data = response.data['data'];
        final kiosk = KioskDetailModel.fromJson(data);
        emit(KioskDetailsSuccess(kiosk));
      } else {
        emit(KioskDetailsFailure(
            response.message ?? 'Failed to fetch kiosk details',
            error: response.error));
      }
    } catch (e) {
      if (isClosed) return;
      emit(KioskDetailsFailure(e.toString()));
    }
  }

  Future<void> updateKiosk(String id, Map<String, dynamic> data) async {
    // Keep current state if success to avoid flickering, or show loading overlay?
    // For simplicity, we just call API and refresh details.
    try {
      final response = await _updateKioskUseCase(id, data);
      if (isClosed) return;
      if (response.isSuccess) {
        getKioskDetails(id); // Refresh data
      } else {
        // ideally emit a temporary error state or use a listener in UI
        emit(KioskDetailsFailure(response.message ?? 'Update failed',
            error: response.error));
      }
    } catch (e) {
      if (isClosed) return;
      emit(KioskDetailsFailure(e.toString()));
    }
  }

  Future<void> changeStatus(String id, bool isActive, String? reason) async {
    try {
      final response = await _changeKioskStatusUseCase(id, isActive, reason);
      if (isClosed) return;
      if (response.isSuccess) {
        getKioskDetails(id); // Refresh data
      } else {
        emit(KioskDetailsFailure(response.message ?? 'Status change failed',
            error: response.error));
      }
    } catch (e) {
      if (isClosed) return;
      emit(KioskDetailsFailure(e.toString()));
    }
  }

  Future<void> adjustDues(String id, double amount, String reason) async {
    try {
      final response = await _adjustKioskDuesUseCase(id, amount, reason);
      if (isClosed) return;
      if (response.isSuccess) {
        getKioskDetails(id); // Refresh data
      } else {
        emit(KioskDetailsFailure(response.message ?? 'Adjust dues failed',
            error: response.error));
      }
    } catch (e) {
      if (isClosed) return;
      emit(KioskDetailsFailure(e.toString()));
    }
  }

  Future<void> collectDue(String kioskId, String dueId, double amount) async {
    try {
      final result = await _collectDueUseCase(dueId, amount);
      if (isClosed) return;

      result.fold(
        (failure) => emit(KioskDetailsFailure(failure.message)),
        (success) => getKioskDetails(kioskId), // Refresh data
      );
    } catch (e) {
      if (isClosed) return;
      emit(KioskDetailsFailure(e.toString()));
    }
  }
}
