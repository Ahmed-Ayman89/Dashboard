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

  // Filter states
  String _currentStatus = 'All';
  String _searchQuery = '';
  DateTime? _fromDate;
  DateTime? _toDate;

  Future<void> getCalls({
    int page = 1,
    String? status,
    String? search,
    DateTime? from,
    DateTime? to,
  }) async {
    _currentPage = page;
    if (status != null) _currentStatus = status;
    if (search != null) _searchQuery = search;
    if (from != null) _fromDate = from;
    if (to != null) _toDate = to;

    emit(CallsLoading());

    try {
      final response = await _getCallsUseCase(
        page: _currentPage,
        limit: _limit,
        status: _currentStatus,
        search: _searchQuery,
        from: _fromDate?.toIso8601String(),
        to: _toDate?.toIso8601String(),
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

  Future<void> changePage(int page) async {
    await getCalls(page: page);
  }

  void updateFilters({
    String? status,
    String? search,
    DateTime? from,
    DateTime? to,
  }) {
    getCalls(
      page: 1, // Reset to first page on filter change
      status: status,
      search: search,
      from: from,
      to: to,
    );
  }

  void clearFilters() {
    _currentStatus = 'All';
    _searchQuery = '';
    _fromDate = null;
    _toDate = null;
    getCalls(page: 1);
  }
}
