class AuditLogModel {
  final String id;
  final String adminName;
  final String action;
  final String target;
  final DateTime timestamp;

  const AuditLogModel({
    required this.id,
    required this.adminName,
    required this.action,
    required this.target,
    required this.timestamp,
  });
}
