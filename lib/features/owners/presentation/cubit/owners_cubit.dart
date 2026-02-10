import 'package:bloc/bloc.dart';
import '../../domain/usecases/get_owners_usecase.dart';
import '../../data/models/owner_model.dart';
import 'package:equatable/equatable.dart';

part 'owners_state.dart';

class OwnersCubit extends Cubit<OwnersState> {
  final GetOwnersUseCase getOwnersUseCase;

  OwnersCubit(this.getOwnersUseCase) : super(OwnersInitial());

  int _currentPage = 1;
  final int _limit = 10;
  List<OwnerModel> _allOwners = [];
  bool _hasReachedMax = false;
  String _currentStatus = 'All';
  String _currentSearch = '';

  Future<void> getOwners({
    bool refresh = false,
    String search = '',
    String? status,
  }) async {
    if (refresh) {
      _currentPage = 1;
      _allOwners = [];
      _hasReachedMax = false;
      _currentSearch = search;
      if (status != null) _currentStatus = status;
      emit(OwnersLoading());
    } else {
      if (_allOwners.isEmpty) {
        emit(OwnersLoading());
      } else if (_hasReachedMax) {
        return;
      } else {
        emit(OwnersLoaded(
          owners: _allOwners,
          total: 0,
          page: _currentPage,
          hasReachedMax: _hasReachedMax,
          isFetchingMore: true,
        ));
      }
    }

    final response = await getOwnersUseCase(
      page: _currentPage,
      limit: _limit,
      search: _currentSearch,
      status: _currentStatus,
    );

    if (isClosed) return;

    if (response.error == null) {
      final data = response.data['data'];
      final List<dynamic> ownersJson = data['owners'];
      final totalinfo = data['total'];

      final newOwners = ownersJson.map((e) => OwnerModel.fromJson(e)).toList();

      if (refresh) {
        _allOwners = newOwners;
      } else {
        _allOwners.addAll(newOwners);
      }

      _hasReachedMax = newOwners.length < _limit;
      if (!_hasReachedMax) {
        _currentPage++;
      }

      emit(OwnersLoaded(
        owners: _allOwners,
        total: totalinfo,
        page: _currentPage - 1,
        hasReachedMax: _hasReachedMax,
        isFetchingMore: false,
      ));
    } else {
      emit(OwnersFailure(message: response.message ?? 'Unknown error'));
    }
  }
}
