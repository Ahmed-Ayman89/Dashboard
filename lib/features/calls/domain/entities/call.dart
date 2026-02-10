class Call {
  final String id;
  final String userId;
  final String number;
  final DateTime date;
  final String? adminId;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final CallUserEntity? user;
  final CallAdminEntity? admin;

  Call({
    required this.id,
    required this.userId,
    required this.number,
    required this.date,
    this.adminId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.admin,
  });
}

class CallUserEntity {
  final String id;
  final String fullName;
  final String? phone;

  CallUserEntity({
    required this.id,
    required this.fullName,
    this.phone,
  });
}

class CallAdminEntity {
  final String id;
  final String fullName;

  CallAdminEntity({
    required this.id,
    required this.fullName,
  });
}
