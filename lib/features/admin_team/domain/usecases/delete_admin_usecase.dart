import '../../../../core/network/api_response.dart';
import '../repositories/admin_repository.dart';

class DeleteAdminUseCase {
  final AdminRepository repository;

  DeleteAdminUseCase(this.repository);

  Future<ApiResponse> call(String id) {
    return repository.deleteAdmin(id);
  }
}
