import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/adjust_customer_balance_usecase.dart';

// States
abstract class CustomerBalanceState extends Equatable {
  const CustomerBalanceState();

  @override
  List<Object> get props => [];
}

class CustomerBalanceInitial extends CustomerBalanceState {}

class CustomerBalanceLoading extends CustomerBalanceState {}

class CustomerBalanceSuccess extends CustomerBalanceState {}

class CustomerBalanceFailure extends CustomerBalanceState {
  final String message;

  const CustomerBalanceFailure(this.message);

  @override
  List<Object> get props => [message];
}

// Cubit
class CustomerBalanceCubit extends Cubit<CustomerBalanceState> {
  final AdjustCustomerBalanceUseCase _adjustCustomerBalanceUseCase;

  CustomerBalanceCubit(this._adjustCustomerBalanceUseCase)
      : super(CustomerBalanceInitial());

  Future<void> adjustBalance({
    required String id,
    required double amount,
    required String reason,
  }) async {
    emit(CustomerBalanceLoading());
    try {
      final response = await _adjustCustomerBalanceUseCase(
        id: id,
        amount: amount,
        reason: reason,
      );

      if (response.isSuccess) {
        emit(CustomerBalanceSuccess());
      } else {
        emit(CustomerBalanceFailure(
            response.message ?? 'Failed to adjust balance'));
      }
    } catch (e) {
      emit(CustomerBalanceFailure(e.toString()));
    }
  }
}
