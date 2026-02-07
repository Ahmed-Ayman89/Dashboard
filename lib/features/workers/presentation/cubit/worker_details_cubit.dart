import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/worker_details_model.dart';
import '../../domain/usecases/ban_worker_usecase.dart';
import '../../domain/usecases/delete_worker_usecase.dart';
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

class WorkerDetailsActionLoading extends WorkerDetailsState {}

class WorkerDetailsActionSuccess extends WorkerDetailsState {
  final String message;

  const WorkerDetailsActionSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class WorkerDetailsActionFailure extends WorkerDetailsState {
  final String message;

  const WorkerDetailsActionFailure(this.message);

  @override
  List<Object> get props => [message];
}

// Cubit
class WorkerDetailsCubit extends Cubit<WorkerDetailsState> {
  final GetWorkerDetailsUseCase _getWorkerDetailsUseCase;
  final DeleteWorkerUseCase _deleteWorkerUseCase;
  final BanWorkerUseCase _banWorkerUseCase;

  WorkerDetailsCubit({
    required GetWorkerDetailsUseCase getWorkerDetailsUseCase,
    required DeleteWorkerUseCase deleteWorkerUseCase,
    required BanWorkerUseCase banWorkerUseCase,
  })  : _getWorkerDetailsUseCase = getWorkerDetailsUseCase,
        _deleteWorkerUseCase = deleteWorkerUseCase,
        _banWorkerUseCase = banWorkerUseCase,
        super(WorkerDetailsInitial());

  Future<void> getWorkerDetails(String id) async {
    emit(WorkerDetailsLoading());
    try {
      final response = await _getWorkerDetailsUseCase(id);
      if (isClosed) return;
      if (response.isSuccess && response.data != null) {
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
      if (isClosed) return;
      emit(WorkerDetailsFailure(e.toString()));
    }
  }

  Future<void> deleteWorker(String id, String kioskId, String profileId) async {
    emit(WorkerDetailsActionLoading());
    try {
      final response = await _deleteWorkerUseCase(id, kioskId, profileId);
      if (isClosed) return;
      if (response.isSuccess) {
        emit(const WorkerDetailsActionSuccess('Worker removed successfully'));
        getWorkerDetails(id); // Refresh details
      } else {
        emit(WorkerDetailsActionFailure(
            response.message ?? 'Failed to delete worker'));
      }
    } catch (e) {
      if (isClosed) return;
      emit(WorkerDetailsActionFailure(e.toString()));
    }
  }

  Future<void> banWorker(String id) async {
    emit(WorkerDetailsActionLoading());
    try {
      final response = await _banWorkerUseCase(id);
      if (isClosed) return;
      if (response.isSuccess) {
        emit(const WorkerDetailsActionSuccess(
            'Worker status updated successfully'));
        getWorkerDetails(id); // Refresh details
      } else {
        emit(WorkerDetailsActionFailure(
            response.message ?? 'Failed to update worker status'));
      }
    } catch (e) {
      if (isClosed) return;
      emit(WorkerDetailsActionFailure(e.toString()));
    }
  }
}
