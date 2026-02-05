import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../dashboard/data/models/kiosk_model.dart';
import '../../domain/usecases/get_kiosks_usecase.dart';
import 'kiosks_state.dart';

class KiosksCubit extends Cubit<KiosksState> {
  final GetKiosksUseCase _getKiosksUseCase;

  KiosksCubit(this._getKiosksUseCase) : super(KiosksInitial());

  Future<void> getKiosks({int page = 1, int limit = 10}) async {
    emit(KiosksLoading());
    try {
      final response = await _getKiosksUseCase(page: page, limit: limit);

      if (response.isSuccess) {
        final data = response.data['data'];
        final List<dynamic> kiosksJson = data['kiosks'];
        final kiosks =
            kiosksJson.map((json) => KioskModel.fromJson(json)).toList();
        final total = data['total'];
        final currentPage = data['page'];
        final currentLimit = data['limit'];

        emit(KiosksSuccess(
          kiosks: kiosks,
          total: total,
          page: currentPage,
          limit: currentLimit,
        ));
      } else {
        emit(KiosksFailure(response.message ?? 'Failed to fetch kiosks',
            error: response.error));
      }
    } catch (e) {
      emit(KiosksFailure(e.toString()));
    }
  }
}
