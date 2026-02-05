import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/worker_details_model.dart';
import '../../domain/usecases/get_worker_details_usecase.dart';

// States
abstract class WorkerDetailsState extends Equatable {
  const WorkerDetailsState();

  @override
  List<Object> get props => [];
}

class WorkerDetailsInitial extends WorkerDetailsState {}

class WorkerDetailsLoading extends WorkerDetailsState {}

class WorkerDetailsLoaded extends WorkerDetailsState {
  final WorkerDetailsModel worker;

  const WorkerDetailsLoaded(this.worker);

  @override
  List<Object> get props => [worker];
}

class WorkerDetailsFailure extends WorkerDetailsState {
  final String message;

  const WorkerDetailsFailure(this.message);

  @override
  List<Object> get props => [message];
}

// Cubit
class WorkerDetailsCubit extends Cubit<WorkerDetailsState> {
  final GetWorkerDetailsUseCase _getWorkerDetailsUseCase;

  WorkerDetailsCubit(this._getWorkerDetailsUseCase)
      : super(WorkerDetailsInitial());

  Future<void> getWorkerDetails(String id) async {
    emit(WorkerDetailsLoading());
    try {
      final response = await _getWorkerDetailsUseCase(id);
      if (response.isSuccess && response.data != null) {
        // Handle data wrapper if present (API typically returns {success:true, data: { ... }})
        final responseData = response.data;
        final innerData = (responseData is Map<String, dynamic> &&
                responseData.containsKey('data'))
            ? responseData['data']
            : responseData;

        final worker =
            WorkerDetailsModel.fromJson(innerData as Map<String, dynamic>);
        emit(WorkerDetailsLoaded(worker));
      } else {
        emit(WorkerDetailsFailure(
            response.message ?? 'Failed to load worker details'));
      }
    } catch (e) {
      emit(WorkerDetailsFailure(e.toString()));
    }
  }
}
