import '../../../../core/network/api_response.dart';
import '../repositories/kiosks_repository.dart';

class UpdateKioskUseCase {
  final KiosksRepository _repository;

  UpdateKioskUseCase(this._repository);

  Future<ApiResponse> call(String id, Map<String, dynamic> data) async {
    return await _repository.updateKiosk(id, data);
  }
}
