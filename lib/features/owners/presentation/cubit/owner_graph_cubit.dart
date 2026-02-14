import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/owner_graph_model.dart';
import '../../domain/usecases/get_owner_graph_usecase.dart';
import 'owner_graph_state.dart';

class OwnerGraphCubit extends Cubit<OwnerGraphState> {
  final GetOwnerGraphUseCase _getOwnerGraphUseCase;

  OwnerGraphCubit(this._getOwnerGraphUseCase) : super(OwnerGraphInitial());

  bool isAccumulative = false;
  String currentFilter = 'weekly';
  String currentResource = 'transactions_amount';

  Future<void> getOwnerGraph({
    required String id,
    String? resource,
    String? filter,
    bool? accumulative,
  }) async {
    if (resource != null) currentResource = resource;
    if (filter != null) currentFilter = filter;
    if (accumulative != null) isAccumulative = accumulative;

    emit(OwnerGraphLoading());
    try {
      final response = await _getOwnerGraphUseCase(
        id: id,
        resource: currentResource,
        filter: currentFilter,
        accumulative: isAccumulative,
      );
      if (response.isSuccess && response.data != null) {
        final Map<String, dynamic> responseData = response.data;
        final innerData = responseData.containsKey('data')
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

  void toggleAccumulative(String id) {
    getOwnerGraph(id: id, accumulative: !isAccumulative);
  }

  void updateFilter(String id, String filter) {
    getOwnerGraph(id: id, filter: filter);
  }

  void updateResource(String id, String resource) {
    getOwnerGraph(id: id, resource: resource);
  }
}
