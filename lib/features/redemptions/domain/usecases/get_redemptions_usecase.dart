import '../../../../core/network/api_response.dart';
import '../repositories/redemptions_repository.dart';

class GetRedemptionsUseCase {
  final RedemptionsRepository repository;

  GetRedemptionsUseCase(this.repository);

  Future<ApiResponse> call({String? status}) {
    return repository.getRedemptions(status: status);
  }
}
