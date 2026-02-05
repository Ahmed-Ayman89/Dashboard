import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/worker_model.dart';
import '../../domain/usecases/get_workers_usecase.dart';
import 'workers_state.dart';

class WorkersCubit extends Cubit<WorkersState> {
  final GetWorkersUseCase _getWorkersUseCase;
  int _currentPage = 1;
  final int _limit = 10;
  String? _searchQuery;

  WorkersCubit(this._getWorkersUseCase) : super(WorkersInitial());

  Future<void> getWorkers({int page = 1, String? search}) async {
    _currentPage = page;
    _searchQuery = search;

    emit(WorkersLoading());

    try {
      final response = await _getWorkersUseCase(
        page: _currentPage,
        limit: _limit,
        search: _searchQuery,
      );

      if (response.isSuccess && response.data != null) {
        final responseData = response.data;
        // Handle data wrapper if present
        final innerData = (responseData is Map<String, dynamic> &&
                responseData.containsKey('data'))
            ? responseData['data']
            : responseData;

        final List<WorkerModel> workers = ((innerData['workers'] ?? []) as List)
            .map((e) => WorkerModel.fromJson(e as Map<String, dynamic>))
            .toList();

        final int total = innerData['total'] ?? 0;
        final int currentPage = innerData['page'] ?? 1;

        emit(WorkersLoaded(
          workers: workers,
          total: total,
          page: currentPage,
          limit: _limit,
        ));
      } else {
        emit(WorkersFailure(response.message ?? 'Failed to load workers'));
      }
    } catch (e) {
      emit(WorkersFailure(e.toString()));
    }
  }

  void searchWorkers(String query) {
    getWorkers(page: 1, search: query);
  }

  void changePage(int page) {
    getWorkers(page: page, search: _searchQuery);
  }
}
