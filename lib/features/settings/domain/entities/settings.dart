import 'package:equatable/equatable.dart';

class Settings extends Equatable {
  final GlobalSettings global;
  final FinancialSettings financial;
  final RulesSettings rules;

  const Settings({
    required this.global,
    required this.financial,
    required this.rules,
  });

  @override
  List<Object?> get props => [global, financial, rules];
}

class GlobalSettings extends Equatable {
  final num dailyKioskLimit;
  final num sameCustomerLimit;
  final num minRedemptionAmount;
  final num minSendingAmount;
  final num goalSetupLimit;
  final num maxKiosksPerOwner;

  const GlobalSettings({
    required this.dailyKioskLimit,
    required this.sameCustomerLimit,
    required this.minRedemptionAmount,
    required this.minSendingAmount,
    required this.goalSetupLimit,
    required this.maxKiosksPerOwner,
  });

  @override
  List<Object?> get props => [
        dailyKioskLimit,
        sameCustomerLimit,
        minRedemptionAmount,
        minSendingAmount,
        goalSetupLimit,
        maxKiosksPerOwner,
      ];
}

class FinancialSettings extends Equatable {
  final num commissionAmount;
  final String commissionType;

  const FinancialSettings({
    required this.commissionAmount,
    required this.commissionType,
  });

  @override
  List<Object?> get props => [commissionAmount, commissionType];
}

class RulesSettings extends Equatable {
  final String kycRequirements;
  final String workerRestrictions;
  final String accountFreezeRules;
  final String termsAndConditions;
  final String privacyPolicy;

  const RulesSettings({
    required this.kycRequirements,
    required this.workerRestrictions,
    required this.accountFreezeRules,
    required this.termsAndConditions,
    required this.privacyPolicy,
  });

  @override
  List<Object?> get props => [
        kycRequirements,
        workerRestrictions,
        accountFreezeRules,
        termsAndConditions,
        privacyPolicy,
      ];
}
