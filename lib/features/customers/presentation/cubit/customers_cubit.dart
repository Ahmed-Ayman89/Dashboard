import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/customer_model.dart';
import '../../domain/usecases/get_customers_usecase.dart';

// States
abstract class CustomersState extends Equatable {
  const CustomersState();

  @override
  List<Object> get props => [];
}

class CustomersInitial extends CustomersState {}

class CustomersLoading extends CustomersState {}

class CustomersLoaded extends CustomersState {
  final List<CustomerModel> customers;
  final int total;
  final int page;
  final int limit;

  const CustomersLoaded({
    required this.customers,
    required this.total,
    required this.page,
    required this.limit,
  });

  @override
  List<Object> get props => [customers, total, page, limit];
}

class CustomersFailure extends CustomersState {
  final String message;

  const CustomersFailure(this.message);

  @override
  List<Object> get props => [message];
}

// Cubit
class CustomersCubit extends Cubit<CustomersState> {
  final GetCustomersUseCase _getCustomersUseCase;
  int _currentPage = 1;
  final int _limit = 10;
  String? _searchQuery;

  CustomersCubit(this._getCustomersUseCase) : super(CustomersInitial());

  Future<void> getCustomers({int page = 1, String? search}) async {
    _currentPage = page;
    // Update search query only if a dynamic search is triggered.
    // If search is null, we check if it's a page change (use existing query)
    // or a reset (should have been handled by searchCustomers('')).
    if (search != null) {
      _searchQuery = search;
    }

    emit(CustomersLoading());

    try {
      final response = await _getCustomersUseCase(
        page: _currentPage,
        limit: _limit,
        search: _searchQuery,
      );

      if (isClosed) return;

      if (response.isSuccess && response.data != null) {
        final dynamic rawData = response.data;
        if (rawData is! Map<String, dynamic>) {
          emit(const CustomersFailure('Invalid response format from server'));
          return;
        }

        List<CustomerModel> customers = [];
        int total = 0;
        int currentPage = 1;

        // format A: { data: { customers: [], total: X, page: Y } }
        // format B: { data: [], pagination: { total: X, page: Y } }

        final dynamic dataField = rawData['data'];
        final dynamic paginationField = rawData['pagination'];

        if (dataField is Map<String, dynamic>) {
          // Format A
          customers = ((dataField['customers'] ?? []) as List)
              .map((e) => CustomerModel.fromJson(e as Map<String, dynamic>))
              .toList();
          total = int.tryParse(dataField['total']?.toString() ?? '0') ?? 0;
          currentPage = int.tryParse(dataField['page']?.toString() ?? '1') ?? 1;
        } else if (dataField is List) {
          // Format B
          customers = dataField
              .map((e) => CustomerModel.fromJson(e as Map<String, dynamic>))
              .toList();

          if (paginationField is Map<String, dynamic>) {
            total =
                int.tryParse(paginationField['total']?.toString() ?? '0') ?? 0;
            currentPage =
                int.tryParse(paginationField['page']?.toString() ?? '1') ?? 1;
          } else {
            // Fallback to top level if pagination object is missing
            total = int.tryParse(rawData['total']?.toString() ?? '0') ??
                customers.length;
            currentPage = int.tryParse(rawData['page']?.toString() ?? '1') ?? 1;
          }
        } else {
          emit(const CustomersFailure('Unexpected data field format'));
          return;
        }

        emit(CustomersLoaded(
          customers: customers,
          total: total,
          page: currentPage,
          limit: _limit,
        ));
      } else {
        emit(CustomersFailure(response.message ?? 'Failed to load customers'));
      }
    } catch (e) {
      if (isClosed) return;
      emit(CustomersFailure(e.toString()));
    }
  }

  void searchCustomers(String query) {
    if (query == _searchQuery) return;
    getCustomers(page: 1, search: query);
  }

  void loadNextPage() {
    if (state is CustomersLoaded) {
      final currentState = state as CustomersLoaded;
      if (currentState.customers.length < currentState.total) {
        getCustomers(page: _currentPage + 1, search: _searchQuery);
      }
    }
  }

  void loadPreviousPage() {
    if (_currentPage > 1) {
      getCustomers(page: _currentPage - 1, search: _searchQuery);
    }
  }
}
