class TransactionModel {
  final String id;
  final double amountGross;
  final double amountNet;
  final double commission;
  final DateTime timestamp;
  final String status;
  final String type;
  final String kiosk;
  final String owner;
  final String worker;
  final String customer;
  final bool isSuspicious;

  TransactionModel({
    required this.id,
    required this.amountGross,
    required this.amountNet,
    required this.commission,
    required this.timestamp,
    required this.status,
    required this.type,
    required this.kiosk,
    required this.owner,
    required this.worker,
    required this.customer,
    required this.isSuspicious,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? '',
      amountGross:
          double.tryParse(json['amount_gross']?.toString() ?? '0') ?? 0.0,
      amountNet: double.tryParse(json['amount_net']?.toString() ?? '0') ?? 0.0,
      commission: double.tryParse(json['commission']?.toString() ?? '0') ?? 0.0,
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
      status: json['status'] ?? 'UNKNOWN',
      type: json['type'] ?? 'UNKNOWN',
      kiosk: json['kiosk'] ?? 'Unknown Kiosk',
      owner: json['owner'] ?? 'Unknown Owner',
      worker: json['worker'] ?? 'Unknown Worker',
      customer: json['customer'] ?? 'Unknown Customer',
      isSuspicious: json['is_suspicious'] ?? false,
    );
  }
}
