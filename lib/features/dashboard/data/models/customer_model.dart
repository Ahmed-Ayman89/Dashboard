class CustomerModel {
  final String id;
  final String phone;
  final double balance;
  final int pointsReceived;
  final int redemptionsCount;
  final bool appDownloaded;
  final int kiosksInteractedCount;
  final bool isSuspended;

  const CustomerModel({
    required this.id,
    required this.phone,
    required this.balance,
    required this.pointsReceived,
    required this.redemptionsCount,
    required this.appDownloaded,
    required this.kiosksInteractedCount,
    this.isSuspended = false,
  });
}
