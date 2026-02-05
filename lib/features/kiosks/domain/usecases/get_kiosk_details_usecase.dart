import '../../../../core/network/api_response.dart';
import '../repositories/kiosks_repository.dart';

class GetKioskDetailsUseCase {
  final KiosksRepository _repository;

  GetKioskDetailsUseCase(this._repository);

  Future<ApiResponse> call(String id) async {
    return await _repository.getKioskDetails(id);
  }
}
