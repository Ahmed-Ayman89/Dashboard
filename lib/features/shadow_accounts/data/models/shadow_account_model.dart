import '../../domain/entities/shadow_account_entity.dart';

class ShadowAccountModel extends ShadowAccountEntity {
  const ShadowAccountModel({
    required super.phone,
    required super.balance,
    super.lastFollowUp,
    required super.lastUpdated,
  });

  factory ShadowAccountModel.fromJson(Map<String, dynamic> json) {
    return ShadowAccountModel(
      phone: json['phone']?.toString() ?? '',
      balance: json['balance']?.toString() ?? '0',
      lastFollowUp: json['last_follow_up']?.toString(),
      lastUpdated: json['last_updated']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'balance': balance,
      'last_follow_up': lastFollowUp,
      'last_updated': lastUpdated,
    };
  }
}
