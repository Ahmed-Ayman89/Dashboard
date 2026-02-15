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
  int _currentPage = 1;
  final int _limit = 10;

  Future<void> getRedemptions({String? status, int page = 1}) async {
    if (status != null) _currentStatus = status;
    _currentPage = page;

    emit(RedemptionsLoading());
    final response = await getRedemptionsUseCase(
      status: _currentStatus,
      page: _currentPage,
      limit: _limit,
    );

    if (isClosed) return;

    if (response.error == null) {
      try {
        final dynamic responseData = response.data['data'];
        List<dynamic> data = [];
        int total = 0;
        int currentPage = 1;
        int limit = 10;

        if (responseData is Map && responseData.containsKey('redemptions')) {
          data = responseData['redemptions'];
          total = responseData['total'] ?? 0;
          currentPage = responseData['page'] ?? 1;
          limit = responseData['limit'] ?? 10;
        } else if (responseData is List) {
          data = responseData;
          total = data.length;
        } else {
          emit(RedemptionsFailure(message: 'Invalid response format'));
          return;
        }

        final List<RedemptionModel> redemptions =
            data.map((e) => RedemptionModel.fromJson(e)).toList();
        emit(RedemptionsLoaded(
          redemptions: redemptions,
          total: total,
          page: currentPage,
          limit: limit,
        ));
      } catch (e) {
        emit(
            RedemptionsFailure(message: 'Error parsing data: ${e.toString()}'));
      }
    } else {
      emit(RedemptionsFailure(message: response.message ?? 'Unknown error'));
    }
  }

  Future<void> changePage(int page) async {
    await getRedemptions(page: page);
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
