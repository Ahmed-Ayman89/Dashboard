import '../../../../core/network/api_response.dart';
import '../repositories/owners_repository.dart';

class GetOwnerDetailsUseCase {
  final OwnersRepository _repository;

  GetOwnerDetailsUseCase(this._repository);

  Future<ApiResponse> call(String id) async {
    return await _repository.getOwnerDetails(id);
  }
}
