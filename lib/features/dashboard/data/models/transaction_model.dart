enum TransactionStatus {
  completed,
  flagged,
  failed,
}

class TransactionModel {
  final String id;
  final String senderName;
  final String kioskName;
  final String customerPhone;
  final int points;
  final double commission;
  final DateTime timestamp;
  final TransactionStatus status;

  const TransactionModel({
    required this.id,
    required this.senderName,
    required this.kioskName,
    required this.customerPhone,
    required this.points,
    required this.commission,
    required this.timestamp,
    required this.status,
  });
}
