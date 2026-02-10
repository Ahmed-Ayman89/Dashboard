import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/call_model.dart';
import '../../domain/usecases/get_call_details_usecase.dart';
import '../../domain/usecases/update_call_status_usecase.dart';

// States
abstract class CallDetailsState extends Equatable {
  const CallDetailsState();

  @override
  List<Object> get props => [];
}

class CallDetailsInitial extends CallDetailsState {}

class CallDetailsLoading extends CallDetailsState {}

class CallDetailsLoaded extends CallDetailsState {
  final CallModel call;

  const CallDetailsLoaded(this.call);

  @override
  List<Object> get props => [call];
}

class CallDetailsFailure extends CallDetailsState {
  final String message;

  const CallDetailsFailure(this.message);

  @override
  List<Object> get props => [message];
}

class CallDetailsUpdating extends CallDetailsState {}

class CallDetailsUpdateSuccess extends CallDetailsState {
  final String message;

  const CallDetailsUpdateSuccess(this.message);

  @override
  List<Object> get props => [message];
}

// Cubit
class CallDetailsCubit extends Cubit<CallDetailsState> {
  final GetCallDetailsUseCase _getCallDetailsUseCase;
  final UpdateCallStatusUseCase? _updateCallStatusUseCase;

  CallDetailsCubit(this._getCallDetailsUseCase,
      {UpdateCallStatusUseCase? updateCallStatusUseCase})
      : _updateCallStatusUseCase = updateCallStatusUseCase,
        super(CallDetailsInitial());

  Future<void> getCallDetails(String id) async {
    emit(CallDetailsLoading());
    try {
      final response = await _getCallDetailsUseCase(id);

      if (isClosed) return;

      if (response.isSuccess && response.data != null) {
        final responseData = response.data;
        // Handle data wrapper
        final innerData = (responseData is Map<String, dynamic> &&
                responseData.containsKey('data'))
            ? responseData['data']
            : responseData;

        final call = CallModel.fromJson(innerData as Map<String, dynamic>);
        emit(CallDetailsLoaded(call));
      } else {
        emit(CallDetailsFailure(
            response.message ?? 'Failed to load call details'));
      }
    } catch (e) {
      if (isClosed) return;
      emit(CallDetailsFailure(e.toString()));
    }
  }

  Future<void> updateStatus(String id, String status) async {
    if (_updateCallStatusUseCase == null) return;
    try {
      final response = await _updateCallStatusUseCase(id, status);

      if (isClosed) return;

      if (response.isSuccess) {
        await getCallDetails(id);
      } else {
        emit(CallDetailsFailure(
            response.message ?? 'Failed to update call status'));
      }
    } catch (e) {
      if (isClosed) return;
      emit(CallDetailsFailure(e.toString()));
    }
  }
}
