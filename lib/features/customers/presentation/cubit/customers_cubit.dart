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
    _searchQuery = search;

    emit(CustomersLoading());

    try {
      final response = await _getCustomersUseCase(
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

        final List<CustomerModel> customers =
            ((innerData['customers'] ?? []) as List)
                .map((e) => CustomerModel.fromJson(e as Map<String, dynamic>))
                .toList();

        final int total = innerData['total'] ?? 0;
        final int currentPage = innerData['page'] ?? 1;

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
