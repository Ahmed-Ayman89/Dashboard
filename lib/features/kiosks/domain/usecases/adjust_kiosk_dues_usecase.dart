import '../../../../core/network/api_response.dart';
import '../repositories/kiosks_repository.dart';

class AdjustKioskDuesUseCase {
  final KiosksRepository _repository;

  AdjustKioskDuesUseCase(this._repository);

  Future<ApiResponse> call(String id, double amount, String reason) async {
    return await _repository.adjustKioskDues(id, amount, reason);
  }
}
