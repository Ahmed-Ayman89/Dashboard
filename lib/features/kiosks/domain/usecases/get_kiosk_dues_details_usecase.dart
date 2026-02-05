import '../../../../core/network/api_response.dart';
import '../repositories/kiosks_repository.dart';

class GetKioskDuesDetailsUseCase {
  final KiosksRepository repository;

  GetKioskDuesDetailsUseCase(this.repository);

  Future<ApiResponse> call(String id) {
    return repository.getKioskDuesDetails(id);
  }
}
