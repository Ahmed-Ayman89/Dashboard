import 'package:dashboard_grow/features/settings/domain/entities/settings.dart';

class SettingsModel extends Settings {
  const SettingsModel({
    required super.global,
    required super.financial,
    required super.rules,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      global: GlobalSettingsModel.fromJson(json['global']),
      financial: FinancialSettingsModel.fromJson(json['financial']),
      rules: RulesSettingsModel.fromJson(json['rules']),
    );
  }
}

class GlobalSettingsModel extends GlobalSettings {
  const GlobalSettingsModel({
    required super.dailyKioskLimit,
    required super.sameCustomerLimit,
    required super.minRedemptionAmount,
    required super.minSendingAmount,
    required super.goalSetupLimit,
    required super.maxKiosksPerOwner,
  });

  factory GlobalSettingsModel.fromJson(Map<String, dynamic> json) {
    return GlobalSettingsModel(
      dailyKioskLimit: json['daily_kiosk_limit'] ?? 0,
      sameCustomerLimit: json['same_customer_limit'] ?? 0,
      minRedemptionAmount: json['min_redemption_amount'] ?? 0,
      minSendingAmount: json['min_sending_amount'] ?? 0,
      goalSetupLimit: json['goal_setup_limit'] ?? 0,
      maxKiosksPerOwner: json['max_kiosks_per_owner'] ?? 0,
    );
  }
}

class FinancialSettingsModel extends FinancialSettings {
  const FinancialSettingsModel({
    required super.commissionAmount,
    required super.commissionType,
  });

  factory FinancialSettingsModel.fromJson(Map<String, dynamic> json) {
    return FinancialSettingsModel(
      commissionAmount: json['commission_amount'] ?? 0,
      commissionType: json['commission_type'] ?? '',
    );
  }
}

class RulesSettingsModel extends RulesSettings {
  const RulesSettingsModel({
    required super.kycRequirements,
    required super.workerRestrictions,
    required super.accountFreezeRules,
    required super.termsAndConditions,
    required super.privacyPolicy,
  });

  factory RulesSettingsModel.fromJson(Map<String, dynamic> json) {
    return RulesSettingsModel(
      kycRequirements: json['kyc_requirements'] ?? '',
      workerRestrictions: json['worker_restrictions'] ?? '',
      accountFreezeRules: json['account_freeze_rules'] ?? '',
      termsAndConditions: json['terms_and_conditions'] ?? '',
      privacyPolicy: json['privacy_policy'] ?? '',
    );
  }
}
