import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/kiosk_graph_model.dart';
import '../../domain/usecases/get_kiosk_graph_usecase.dart';
import 'kiosk_graph_state.dart';

class KioskGraphCubit extends Cubit<KioskGraphState> {
  final GetKioskGraphUseCase _getKioskGraphUseCase;

  KioskGraphCubit(this._getKioskGraphUseCase) : super(KioskGraphInitial());

  Future<void> getKioskGraph({
    required String id,
    String resource = 'commission_earned',
    String filter = '7d',
    bool accumulative = true,
  }) async {
    emit(KioskGraphLoading());
    try {
      final response = await _getKioskGraphUseCase(
        id: id,
        resource: resource,
        filter: filter,
        accumulative: accumulative,
      );
      if (response.isSuccess && response.data != null) {
        final responseData = response.data;
        final innerData = (responseData is Map<String, dynamic> &&
                responseData.containsKey('data'))
            ? responseData['data']
            : responseData;
        final graphData =
            KioskGraphModel.fromJson(innerData as Map<String, dynamic>);
        emit(KioskGraphLoaded(graphData));
      } else {
        emit(KioskGraphFailure(response.message ?? 'Failed to load graph'));
      }
    } catch (e) {
      emit(KioskGraphFailure(e.toString()));
    }
  }
}
