class DuesModel {
  final String kioskId;
  final String kioskName;
  final String ownerName;
  final double totalDues;
  final double paidAmount;
  final DateTime lastPaymentDate;
  final int daysSinceLastPayment;

  const DuesModel({
    required this.kioskId,
    required this.kioskName,
    required this.ownerName,
    required this.totalDues,
    required this.paidAmount,
    required this.lastPaymentDate,
    required this.daysSinceLastPayment,
  });

  double get outstanding => totalDues - paidAmount;
  bool get isHighRisk => outstanding > 1000 || daysSinceLastPayment > 10;
}
