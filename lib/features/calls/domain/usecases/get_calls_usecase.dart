import 'package:dashboard_grow/core/network/api_response.dart';
import '../repositories/calls_repository.dart';

class GetCallsUseCase {
  final CallsRepository _callsRepository;

  GetCallsUseCase(this._callsRepository);

  Future<ApiResponse> call({int page = 1, int limit = 10}) {
    return _callsRepository.getCalls(page: page, limit: limit);
  }
}
