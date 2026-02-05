import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/customer_details_model.dart';
import '../../domain/usecases/get_customer_details_usecase.dart';

// States
abstract class CustomerDetailsState extends Equatable {
  const CustomerDetailsState();

  @override
  List<Object> get props => [];
}

class CustomerDetailsInitial extends CustomerDetailsState {}

class CustomerDetailsLoading extends CustomerDetailsState {}

class CustomerDetailsLoaded extends CustomerDetailsState {
  final CustomerDetailsModel customer;

  const CustomerDetailsLoaded(this.customer);

  @override
  List<Object> get props => [customer];
}

class CustomerDetailsFailure extends CustomerDetailsState {
  final String message;

  const CustomerDetailsFailure(this.message);

  @override
  List<Object> get props => [message];
}

// Cubit
class CustomerDetailsCubit extends Cubit<CustomerDetailsState> {
  final GetCustomerDetailsUseCase _getCustomerDetailsUseCase;

  CustomerDetailsCubit(this._getCustomerDetailsUseCase)
      : super(CustomerDetailsInitial());

  Future<void> getCustomerDetails(String id) async {
    emit(CustomerDetailsLoading());
    try {
      final response = await _getCustomerDetailsUseCase(id);
      if (response.isSuccess && response.data != null) {
        final responseData = response.data;
        // Handle data wrapper
        final innerData = (responseData is Map<String, dynamic> &&
                responseData.containsKey('data'))
            ? responseData['data']
            : responseData;

        final customer =
            CustomerDetailsModel.fromJson(innerData as Map<String, dynamic>);
        emit(CustomerDetailsLoaded(customer));
      } else {
        emit(CustomerDetailsFailure(
            response.message ?? 'Failed to load customer details'));
      }
    } catch (e) {
      emit(CustomerDetailsFailure(e.toString()));
    }
  }
}
