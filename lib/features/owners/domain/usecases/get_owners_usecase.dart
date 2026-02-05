import '../../../../core/network/api_response.dart';
import '../repositories/owners_repository.dart';

class GetOwnersUseCase {
  final OwnersRepository _repository;

  GetOwnersUseCase(this._repository);

  Future<ApiResponse> call({
    int page = 1,
    int limit = 10,
    String search = '',
  }) async {
    return await _repository.getOwners(
      page: page,
      limit: limit,
      search: search,
    );
  }
}
