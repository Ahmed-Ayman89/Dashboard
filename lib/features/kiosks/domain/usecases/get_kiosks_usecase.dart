import '../../../../core/network/api_response.dart';
import '../repositories/kiosks_repository.dart';

class GetKiosksUseCase {
  final KiosksRepository _repository;

  GetKiosksUseCase(this._repository);

  Future<ApiResponse> call({
    int page = 1,
    int limit = 10,
    String search = '',
    String? status,
  }) async {
    return await _repository.getKiosks(
      page: page,
      limit: limit,
      search: search,
      status: status,
    );
  }
}
