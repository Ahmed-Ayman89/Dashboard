import 'package:dashboard_grow/features/settings/data/models/settings_model.dart';

class SettingsResponseModel {
  final bool success;
  final String message;
  final SettingsModel? data;

  SettingsResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory SettingsResponseModel.fromJson(Map<String, dynamic> json) {
    return SettingsResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? SettingsModel.fromJson(json['data']) : null,
    );
  }
}
