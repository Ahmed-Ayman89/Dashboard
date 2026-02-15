import '../../../../core/network/api_response.dart';
import '../../domain/repositories/kiosks_repository.dart';

class GetKioskGraphUseCase {
  final KiosksRepository _repository;

  GetKioskGraphUseCase(this._repository);

  Future<ApiResponse> call({
    required String id,
    String resource = 'commission_earned',
    String filter = '7d',
    bool accumulative = true,
  }) async {
    return await _repository.getKioskGraph(
      id: id,
      resource: resource,
      filter: filter,
      accumulative: accumulative,
    );
  }
}
