import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/owner_graph_model.dart';
import '../../domain/usecases/get_owner_graph_usecase.dart';
import 'owner_graph_state.dart';

class OwnerGraphCubit extends Cubit<OwnerGraphState> {
  final GetOwnerGraphUseCase _getOwnerGraphUseCase;

  OwnerGraphCubit(this._getOwnerGraphUseCase) : super(OwnerGraphInitial());

  Future<void> getOwnerGraph({
    required String id,
    String resource = 'transactions_amount',
    String filter = 'weekly',
  }) async {
    emit(OwnerGraphLoading());
    try {
      final response = await _getOwnerGraphUseCase(
        id: id,
        resource: resource,
        filter: filter,
      );
      if (response.isSuccess && response.data != null) {
        final responseData = response.data;
        final innerData = (responseData is Map<String, dynamic> &&
                responseData.containsKey('data'))
            ? responseData['data']
            : responseData;
        final graphData =
            OwnerGraphModel.fromJson(innerData as Map<String, dynamic>);
        emit(OwnerGraphLoaded(graphData));
      } else {
        emit(OwnerGraphFailure(response.message ?? 'Failed to load graph'));
      }
    } catch (e) {
      emit(OwnerGraphFailure(e.toString()));
    }
  }
}
