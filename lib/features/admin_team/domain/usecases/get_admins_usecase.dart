import '../../../../core/network/api_response.dart';
import '../repositories/admin_repository.dart';

class GetAdminsUseCase {
  final AdminRepository repository;

  GetAdminsUseCase(this.repository);

  Future<ApiResponse> call() {
    return repository.getAdmins();
  }
}
