import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/redemption_model.dart';
import '../../domain/usecases/get_redemptions_usecase.dart';
import '../../domain/usecases/process_redemption_usecase.dart';

part 'redemptions_state.dart';

class RedemptionsCubit extends Cubit<RedemptionsState> {
  final GetRedemptionsUseCase getRedemptionsUseCase;
  final ProcessRedemptionUseCase processRedemptionUseCase;

  RedemptionsCubit(this.getRedemptionsUseCase, this.processRedemptionUseCase)
      : super(RedemptionsInitial());

  String _currentStatus = 'PENDING';

  Future<void> getRedemptions({String? status}) async {
    if (status != null) _currentStatus = status;
    emit(RedemptionsLoading());
    final response = await getRedemptionsUseCase(status: _currentStatus);
    if (isClosed) return;

    if (response.error == null) {
      final List<dynamic> data = response.data['data']['redemptions'];
      final List<RedemptionModel> redemptions =
          data.map((e) => RedemptionModel.fromJson(e)).toList();
      emit(RedemptionsLoaded(redemptions: redemptions));
    } else {
      emit(RedemptionsFailure(message: response.message ?? 'Unknown error'));
    }
  }

  Future<void> processRedemption({
    required String id,
    required String action, // 'APPROVE' or 'REJECT'
    required String note,
  }) async {
    // Keep loading state but maybe we want to show a dialog loading.
    // Ideally we'd have a separate status or just re-emit loading.
    // For simplicity, we can emit Loading then refresh.
    emit(RedemptionsLoading());
    final response = await processRedemptionUseCase(
      id: id,
      action: action,
      note: note,
    );
    if (isClosed) return;

    if (response.error == null) {
      emit(RedemptionProcessSuccess(
          message: response.message ?? 'Redemption processed successfully'));
      await getRedemptions(); // Refresh list
    } else {
      emit(RedemptionsFailure(message: response.message ?? 'Unknown error'));
      await getRedemptions(); // Refresh list to show data again
    }
  }
}
