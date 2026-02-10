import 'package:dashboard_grow/core/network/api_response.dart';
import '../repositories/calls_repository.dart';

class GetCallDetailsUseCase {
  final CallsRepository _callsRepository;

  GetCallDetailsUseCase(this._callsRepository);

  Future<ApiResponse> call(String id) {
    return _callsRepository.getCallDetails(id);
  }
}
