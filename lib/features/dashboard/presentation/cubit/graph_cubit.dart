import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_graph_data_usecase.dart';
import 'graph_state.dart';

class GraphCubit extends Cubit<GraphState> {
  final GetGraphDataUseCase getGraphDataUseCase;

  String currentFilter = '7d';
  String currentResource = 'transactions';
  bool isAccumulative = false;
  String? customFromDate;
  String? customToDate;

  GraphCubit(this.getGraphDataUseCase) : super(GraphInitial());

  Future<void> loadGraphData({
    String? filter,
    String? resource,
    bool? accumulative,
    String? from,
    String? to,
  }) async {
    // Update current values if provided
    if (filter != null) currentFilter = filter;
    if (resource != null) currentResource = resource;
    if (accumulative != null) isAccumulative = accumulative;
    if (from != null) customFromDate = from;
    if (to != null) customToDate = to;

    emit(GraphLoading());

    final result = await getGraphDataUseCase(
      filter: currentFilter,
      resource: currentResource,
      accumulative: isAccumulative,
      from: customFromDate,
      to: customToDate,
    );

    result.fold(
      (failure) => emit(GraphError(failure.message)),
      (graphData) => emit(GraphSuccess(graphData)),
    );
  }

  void updateFilter(String newFilter) {
    loadGraphData(filter: newFilter);
  }

  void updateResource(String newResource) {
    loadGraphData(resource: newResource);
  }

  void toggleAccumulative(bool value) {
    loadGraphData(accumulative: value);
  }

  void updateCustomDateRange(String fromDate, String toDate) {
    loadGraphData(filter: 'custom', from: fromDate, to: toDate);
  }
}
