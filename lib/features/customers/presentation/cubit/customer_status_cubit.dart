import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/update_customer_status_usecase.dart';

// States
abstract class CustomerStatusState extends Equatable {
  const CustomerStatusState();

  @override
  List<Object> get props => [];
}

class CustomerStatusInitial extends CustomerStatusState {}

class CustomerStatusLoading extends CustomerStatusState {}

class CustomerStatusSuccess extends CustomerStatusState {}

class CustomerStatusFailure extends CustomerStatusState {
  final String message;

  const CustomerStatusFailure(this.message);

  @override
  List<Object> get props => [message];
}

// Cubit
class CustomerStatusCubit extends Cubit<CustomerStatusState> {
  final UpdateCustomerStatusUseCase _updateCustomerStatusUseCase;

  CustomerStatusCubit(this._updateCustomerStatusUseCase)
      : super(CustomerStatusInitial());

  Future<void> updateStatus({
    required String id,
    required String status,
    required String note,
  }) async {
    emit(CustomerStatusLoading());
    try {
      final response = await _updateCustomerStatusUseCase(
        id: id,
        status: status,
        note: note,
      );

      if (response.isSuccess) {
        emit(CustomerStatusSuccess());
      } else {
        emit(CustomerStatusFailure(
            response.message ?? 'Failed to update status'));
      }
    } catch (e) {
      emit(CustomerStatusFailure(e.toString()));
    }
  }
}
