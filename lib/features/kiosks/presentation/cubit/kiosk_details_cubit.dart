import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_kiosk_details_usecase.dart';
import '../../domain/usecases/update_kiosk_usecase.dart';
import '../../domain/usecases/change_kiosk_status_usecase.dart';
import '../../domain/usecases/adjust_kiosk_dues_usecase.dart';
import '../../../dashboard/data/models/kiosk_detail_model.dart';
import 'kiosk_details_state.dart';

class KioskDetailsCubit extends Cubit<KioskDetailsState> {
  final GetKioskDetailsUseCase _getKioskDetailsUseCase;
  final UpdateKioskUseCase _updateKioskUseCase;
  final ChangeKioskStatusUseCase _changeKioskStatusUseCase;
  final AdjustKioskDuesUseCase _adjustKioskDuesUseCase;

  KioskDetailsCubit(
    this._getKioskDetailsUseCase,
    this._updateKioskUseCase,
    this._changeKioskStatusUseCase,
    this._adjustKioskDuesUseCase,
  ) : super(KioskDetailsInitial());

  Future<void> getKioskDetails(String id) async {
    emit(KioskDetailsLoading());
    try {
      final response = await _getKioskDetailsUseCase(id);

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
      emit(KioskDetailsFailure(e.toString()));
    }
  }

  Future<void> updateKiosk(String id, Map<String, dynamic> data) async {
    // Keep current state if success to avoid flickering, or show loading overlay?
    // For simplicity, we just call API and refresh details.
    try {
      final response = await _updateKioskUseCase(id, data);
      if (response.isSuccess) {
        getKioskDetails(id); // Refresh data
      } else {
        // ideally emit a temporary error state or use a listener in UI
        emit(KioskDetailsFailure(response.message ?? 'Update failed',
            error: response.error));
      }
    } catch (e) {
      emit(KioskDetailsFailure(e.toString()));
    }
  }

  Future<void> changeStatus(String id, bool isActive, String? reason) async {
    try {
      final response = await _changeKioskStatusUseCase(id, isActive, reason);
      if (response.isSuccess) {
        getKioskDetails(id); // Refresh data
      } else {
        emit(KioskDetailsFailure(response.message ?? 'Status change failed',
            error: response.error));
      }
    } catch (e) {
      emit(KioskDetailsFailure(e.toString()));
    }
  }

  Future<void> adjustDues(String id, double amount, String reason) async {
    try {
      final response = await _adjustKioskDuesUseCase(id, amount, reason);
      if (response.isSuccess) {
        getKioskDetails(id); // Refresh data
      } else {
        emit(KioskDetailsFailure(response.message ?? 'Adjust dues failed',
            error: response.error));
      }
    } catch (e) {
      emit(KioskDetailsFailure(e.toString()));
    }
  }
}
