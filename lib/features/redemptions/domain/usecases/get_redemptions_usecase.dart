import '../../../../core/network/api_response.dart';
import '../repositories/redemptions_repository.dart';

class GetRedemptionsUseCase {
  final RedemptionsRepository repository;

  GetRedemptionsUseCase(this.repository);

  Future<ApiResponse> call({
    String? status,
    int page = 1,
    int limit = 10,
  }) {
    return repository.getRedemptions(status: status, page: page, limit: limit);
  }
}
