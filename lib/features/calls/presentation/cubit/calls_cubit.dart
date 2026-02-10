import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/call_model.dart';
import '../../domain/usecases/get_calls_usecase.dart';

// States
abstract class CallsState extends Equatable {
  const CallsState();

  @override
  List<Object> get props => [];
}

class CallsInitial extends CallsState {}

class CallsLoading extends CallsState {}

class CallsLoaded extends CallsState {
  final List<CallModel> calls;
  final int total;
  final int page;
  final int limit;

  const CallsLoaded({
    required this.calls,
    required this.total,
    required this.page,
    required this.limit,
  });

  @override
  List<Object> get props => [calls, total, page, limit];
}

class CallsFailure extends CallsState {
  final String message;

  const CallsFailure(this.message);

  @override
  List<Object> get props => [message];
}

// Cubit
class CallsCubit extends Cubit<CallsState> {
  final GetCallsUseCase _getCallsUseCase;
  int _currentPage = 1;
  final int _limit = 10;

  CallsCubit(this._getCallsUseCase) : super(CallsInitial());

  Future<void> getCalls({int page = 1}) async {
    _currentPage = page;

    if (page == 1) {
      emit(CallsLoading());
    }

    try {
      final response = await _getCallsUseCase(
        page: _currentPage,
        limit: _limit,
      );

      if (isClosed) return;

      if (response.isSuccess && response.data != null) {
        final responseData = response.data;
        // Handle data wrapper if present
        final innerData = (responseData is Map<String, dynamic> &&
                responseData.containsKey('data'))
            ? responseData['data']
            : responseData;

        final List<CallModel> calls = ((innerData['calls'] ?? []) as List)
            .map((e) => CallModel.fromJson(e as Map<String, dynamic>))
            .toList();

        final int total = innerData['total'] ?? 0;
        final int currentPage = innerData['page'] ?? 1;

        emit(CallsLoaded(
          calls: calls,
          total: total,
          page: currentPage,
          limit: _limit,
        ));
      } else {
        emit(CallsFailure(response.message ?? 'Failed to load calls'));
      }
    } catch (e) {
      if (isClosed) return;
      emit(CallsFailure(e.toString()));
    }
  }

  void loadNextPage() {
    if (state is CallsLoaded) {
      final currentState = state as CallsLoaded;
      if (currentState.calls.length < currentState.total) {
        // Logic depends on if list is accumulative or replaced. Using replace for pagination usually
        // If we want infinite scroll, we need to append. But the current implementation replaces.
        // Assuming standard pagination where we just load next page.
        getCalls(page: _currentPage + 1);
      }
    }
  }

  void loadPreviousPage() {
    if (_currentPage > 1) {
      getCalls(page: _currentPage - 1);
    }
  }
}
