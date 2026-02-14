import 'package:bloc/bloc.dart';
import '../../domain/usecases/get_owners_usecase.dart';
import '../../data/models/owner_model.dart';
import 'package:equatable/equatable.dart';

part 'owners_state.dart';

class OwnersCubit extends Cubit<OwnersState> {
  final GetOwnersUseCase getOwnersUseCase;

  OwnersCubit(this.getOwnersUseCase) : super(OwnersInitial());

  String _currentStatus = 'All';
  String _currentSearch = '';

  Future<void> getOwners({
    int page = 1,
    int limit = 10,
    String search = '',
    String? status,
  }) async {
    _currentSearch = search;
    if (status != null) _currentStatus = status;

    emit(OwnersLoading());

    final response = await getOwnersUseCase(
      page: page,
      limit: limit,
      search: _currentSearch,
      status: _currentStatus,
    );

    if (isClosed) return;

    if (response.error == null && response.data != null) {
      final Map<String, dynamic> responseData = response.data;

      // Handle the nested structure: { "data": { "owners": [...], "total": 22, ... } }
      final Map<String, dynamic> data = responseData.containsKey('data')
          ? responseData['data']
          : responseData;

      final List<dynamic> ownersJson = data['owners'] ?? [];
      final int total = data['total'] ?? 0;
      final int responsePage = data['page'] ?? page;
      final int responseLimit = data['limit'] ?? limit;

      final owners = ownersJson.map((e) => OwnerModel.fromJson(e)).toList();

      emit(OwnersLoaded(
        owners: owners,
        total: total,
        page: responsePage,
        limit: responseLimit,
        hasReachedMax: owners.length < responseLimit,
        isFetchingMore: false,
      ));
    } else {
      emit(OwnersFailure(message: response.message ?? 'Unknown error'));
    }
  }
}
