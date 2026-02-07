import 'package:dashboard_grow/core/network/api_endpoiont.dart';
import 'package:dashboard_grow/core/network/api_helper.dart';
import 'package:dashboard_grow/features/dues/data/models/due_model.dart';
import 'package:dashboard_grow/features/dues/data/models/dues_dashboard_model.dart';

abstract class DuesRemoteDataSource {
  Future<DueResponseModel> getDues();
  Future<DuesDashboardResponse> getDuesDashboard();
  Future<void> collectDue(String dueId, double amount);
}

class DuesRemoteDataSourceImpl implements DuesRemoteDataSource {
  final APIHelper apiHelper;

  DuesRemoteDataSourceImpl({required this.apiHelper});

  @override
  Future<DueResponseModel> getDues() async {
    final response = await apiHelper.getRequest(endPoint: EndPoints.dues);
    return DueResponseModel.fromJson(response.data);
  }

  @override
  Future<DuesDashboardResponse> getDuesDashboard() async {
    final response =
        await apiHelper.getRequest(endPoint: '${EndPoints.dues}/dashboard');
    return DuesDashboardResponse.fromJson(response.data);
  }

  @override
  Future<void> collectDue(String dueId, double amount) async {
    await apiHelper.postRequest(
      endPoint: EndPoints.collectDue,
      data: {
        'dueId': dueId,
        'amount': amount,
      },
      isFormData: false,
    );
  }
}
