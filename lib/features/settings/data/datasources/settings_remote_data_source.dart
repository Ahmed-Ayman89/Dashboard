import 'package:dashboard_grow/core/network/api_endpoiont.dart';
import 'package:dashboard_grow/core/network/api_helper.dart';
import 'package:dashboard_grow/features/settings/data/models/settings_response_model.dart';
import 'package:dashboard_grow/features/settings/data/models/settings_model.dart';

abstract class SettingsRemoteDataSource {
  Future<SettingsModel> getSettings();
  Future<void> updateSettings(String key, dynamic value, String description);
}

class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  final APIHelper apiHelper;

  SettingsRemoteDataSourceImpl({required this.apiHelper});

  @override
  Future<SettingsModel> getSettings() async {
    final response = await apiHelper.getRequest(endPoint: EndPoints.settings);
    final settingsResponse = SettingsResponseModel.fromJson(response.data);
    if (settingsResponse.data != null) {
      return settingsResponse.data!;
    } else {
      throw Exception(settingsResponse.message);
    }
  }

  @override
  Future<void> updateSettings(
      String key, dynamic value, String description) async {
    await apiHelper.putRequest(
      endPoint: EndPoints.settings,
      data: {
        'key': key,
        'value': value,
        'description': description,
      },
    );
  }
}
