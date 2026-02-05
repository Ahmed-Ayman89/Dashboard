part of 'transactions_cubit.dart';

abstract class TransactionsState extends Equatable {
  const TransactionsState();

  @override
  List<Object> get props => [];
}

class TransactionsInitial extends TransactionsState {}

class TransactionsLoading extends TransactionsState {}

class TransactionsLoaded extends TransactionsState {
  final List<TransactionModel> transactions;
  final int total;
  final int page;
  final bool hasReachedMax;
  final bool isFetchingMore;

  const TransactionsLoaded({
    required this.transactions,
    required this.total,
    required this.page,
    required this.hasReachedMax,
    this.isFetchingMore = false,
  });

  @override
  List<Object> get props =>
      [transactions, total, page, hasReachedMax, isFetchingMore];
}

class TransactionsFailure extends TransactionsState {
  final String message;

  const TransactionsFailure({required this.message});

  @override
  List<Object> get props => [message];
}
