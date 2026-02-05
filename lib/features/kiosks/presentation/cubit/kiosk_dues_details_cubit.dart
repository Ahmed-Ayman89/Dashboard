import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/network/api_response.dart';
import '../../data/models/kiosk_dues_details_model.dart';
import '../../domain/usecases/get_kiosk_dues_details_usecase.dart';

part 'kiosk_dues_details_state.dart';

class KioskDuesDetailsCubit extends Cubit<KioskDuesDetailsState> {
  final GetKioskDuesDetailsUseCase _getKioskDuesDetailsUseCase;

  KioskDuesDetailsCubit(this._getKioskDuesDetailsUseCase)
      : super(KioskDuesDetailsInitial());

  Future<void> getDuesDetails(String id) async {
    emit(KioskDuesDetailsLoading());
    try {
      final response = await _getKioskDuesDetailsUseCase(id);
      if (response.isSuccess && response.data != null) {
        final responseData = response.data;
        // Check if responseData has a 'data' field (standard API wrapper)
        final innerData = (responseData is Map<String, dynamic> &&
                responseData.containsKey('data'))
            ? responseData['data']
            : responseData;

        final details = KioskDuesDetailsModel.fromJson(innerData);
        emit(KioskDuesDetailsSuccess(details));
      } else {
        emit(KioskDuesDetailsFailure(
            response.message ?? 'Failed to load dues details'));
      }
    } catch (e) {
      emit(KioskDuesDetailsFailure(e.toString()));
    }
  }
}
