import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/worker_graph_model.dart';
import '../../domain/usecases/get_worker_graph_usecase.dart';
import 'worker_graph_state.dart';

class WorkerGraphCubit extends Cubit<WorkerGraphState> {
  final GetWorkerGraphUseCase _getWorkerGraphUseCase;

  WorkerGraphCubit(this._getWorkerGraphUseCase) : super(WorkerGraphInitial());

  Future<void> getWorkerGraph({
    required String id,
    String resource = 'transactions_amount',
    String filter = 'weekly',
    bool accumulative = true,
  }) async {
    emit(WorkerGraphLoading());
    try {
      final response = await _getWorkerGraphUseCase(
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
            WorkerGraphModel.fromJson(innerData as Map<String, dynamic>);
        emit(WorkerGraphLoaded(graphData));
      } else {
        emit(WorkerGraphFailure(response.message ?? 'Failed to load graph'));
      }
    } catch (e) {
      emit(WorkerGraphFailure(e.toString()));
    }
  }
}
