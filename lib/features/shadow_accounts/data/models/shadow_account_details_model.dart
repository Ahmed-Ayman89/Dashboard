import '../../domain/entities/shadow_account_details_entity.dart';
import 'shadow_account_model.dart';

class ShadowAccountDetailsModel extends ShadowAccountDetailsEntity {
  const ShadowAccountDetailsModel({
    required super.shadowAccount,
    required super.transactions,
  });

  factory ShadowAccountDetailsModel.fromJson(Map<String, dynamic> json) {
    final accountJson = json['shadowAccount'] ?? {};
    final transactionsJson = (json['transactions'] as List? ?? []);

    return ShadowAccountDetailsModel(
      shadowAccount: ShadowAccountModel.fromJson(accountJson),
      transactions: transactionsJson
          .map((t) => ShadowAccountTransactionModel.fromJson(t))
          .toList(),
    );
  }
}

class ShadowAccountTransactionModel extends ShadowAccountTransactionEntity {
  ShadowAccountTransactionModel({
    required super.amountNet,
    required super.senderPhone,
    required super.senderName,
    required super.senderRole,
    required super.kioskName,
    required super.createdAt,
  });

  factory ShadowAccountTransactionModel.fromJson(Map<String, dynamic> json) {
    final senderJson = json['sender'] ?? {};
    final kioskJson = json['kiosk'] ?? {};

    return ShadowAccountTransactionModel(
      amountNet: json['amount_net'] ?? '0',
      senderPhone: senderJson['phone'] ?? '',
      senderName: senderJson['full_name'] ?? '',
      senderRole: senderJson['role'] ?? '',
      kioskName: kioskJson['name'] ?? '',
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }
}
