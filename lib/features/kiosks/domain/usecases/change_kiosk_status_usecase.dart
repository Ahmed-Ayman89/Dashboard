import '../../../../core/network/api_response.dart';
import '../repositories/kiosks_repository.dart';

class ChangeKioskStatusUseCase {
  final KiosksRepository _repository;

  ChangeKioskStatusUseCase(this._repository);

  Future<ApiResponse> call(String id, bool isActive, String? reason) async {
    return await _repository.changeKioskStatus(id, isActive, reason);
  }
}
