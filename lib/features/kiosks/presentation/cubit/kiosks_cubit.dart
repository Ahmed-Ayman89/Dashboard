import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../dashboard/data/models/kiosk_model.dart';
import '../../domain/usecases/get_kiosks_usecase.dart';
import 'kiosks_state.dart';

class KiosksCubit extends Cubit<KiosksState> {
  final GetKiosksUseCase _getKiosksUseCase;

  KiosksCubit(this._getKiosksUseCase) : super(KiosksInitial());

  String _currentSearch = '';
  String? _currentStatus;

  Future<void> getKiosks({
    int page = 1,
    int limit = 10,
    String search = '',
    String? status,
  }) async {
    _currentSearch = search;
    if (status != null) _currentStatus = status;

    emit(KiosksLoading());
    try {
      final response = await _getKiosksUseCase(
        page: page,
        limit: limit,
        search: _currentSearch,
        status: _currentStatus,
      );

      if (isClosed) return;

      if (response.isSuccess && response.data != null) {
        final Map<String, dynamic> responseData = response.data;
        final data = responseData.containsKey('data')
            ? responseData['data']
            : responseData;

        final List<dynamic> kiosksJson = data['kiosks'] ?? [];
        final kiosks =
            kiosksJson.map((json) => KioskModel.fromJson(json)).toList();
        final total = data['total'] ?? 0;
        final currentPage = data['page'] ?? page;
        final currentLimit = data['limit'] ?? limit;

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
      if (isClosed) return;
      emit(KiosksFailure(e.toString()));
    }
  }
}
