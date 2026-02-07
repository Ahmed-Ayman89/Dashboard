import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/transaction_model.dart';
import '../../domain/usecases/get_transactions_usecase.dart';

part 'transactions_state.dart';

class TransactionsCubit extends Cubit<TransactionsState> {
  final GetTransactionsUseCase getTransactionsUseCase;
  int _currentPage = 1;
  final int _limit = 20;
  List<TransactionModel> _allTransactions = [];
  bool _hasReachedMax = false;

  TransactionsCubit(this.getTransactionsUseCase) : super(TransactionsInitial());

  Future<void> getTransactions({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _allTransactions = [];
      _hasReachedMax = false;
      emit(TransactionsLoading());
    } else {
      if (_allTransactions.isEmpty) {
        emit(TransactionsLoading());
      } else {
        emit(TransactionsLoaded(
          transactions: _allTransactions,
          total: 0,
          page: _currentPage,
          hasReachedMax: _hasReachedMax,
          isFetchingMore: true,
        ));
      }
    }

    final response = await getTransactionsUseCase(
      page: _currentPage,
      limit: _limit,
    );

    if (isClosed) return;

    if (response.error == null) {
      final List<dynamic> data = response.data['data']['transactions'];
      final int total = response.data['data']['total'] ?? 0;
      final List<TransactionModel> newTransactions =
          data.map((e) => TransactionModel.fromJson(e)).toList();

      if (refresh) {
        _allTransactions = newTransactions;
      } else {
        _allTransactions.addAll(newTransactions);
      }

      if (newTransactions.length < _limit) {
        _hasReachedMax = true;
      } else {
        _currentPage++;
      }

      emit(TransactionsLoaded(
        transactions: _allTransactions,
        total: total,
        page: _currentPage - 1,
        hasReachedMax: _hasReachedMax,
        isFetchingMore: false,
      ));
    } else {
      emit(TransactionsFailure(message: response.message ?? 'Unknown error'));
    }
  }
}
