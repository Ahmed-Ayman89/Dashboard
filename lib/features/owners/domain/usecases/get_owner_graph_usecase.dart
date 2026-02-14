import '../../../../core/network/api_response.dart';
import '../../domain/repositories/owners_repository.dart';

class GetOwnerGraphUseCase {
  final OwnersRepository _repository;

  GetOwnerGraphUseCase(this._repository);

  Future<ApiResponse> call({
    required String id,
    String resource = 'transactions_amount',
    String filter = 'weekly',
    bool accumulative = false,
  }) async {
    return await _repository.getOwnerGraph(
      id: id,
      resource: resource,
      filter: filter,
      accumulative: accumulative,
    );
  }
}
