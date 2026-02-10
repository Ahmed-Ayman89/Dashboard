import 'package:dashboard_grow/core/network/api_response.dart';
import '../repositories/calls_repository.dart';

class UpdateCallStatusUseCase {
  final CallsRepository _callsRepository;

  UpdateCallStatusUseCase(this._callsRepository);

  Future<ApiResponse> call(String id, String status) {
    return _callsRepository.updateCallStatus(id, status);
  }
}
