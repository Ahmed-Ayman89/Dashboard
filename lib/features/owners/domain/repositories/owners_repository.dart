import '../../../../core/network/api_response.dart';

abstract class OwnersRepository {
  Future<ApiResponse> getOwners({
    int page = 1,
    int limit = 10,
    String search = '',
    String? status,
  });

  Future<ApiResponse> getOwnerDetails(String id);

  Future<ApiResponse> performAction({
    required String id,
    required String action,
    required String reason,
  });

  Future<ApiResponse> getOwnerGraph({
    required String id,
    String resource = 'transactions_amount',
    String filter = 'weekly',
  });
}
