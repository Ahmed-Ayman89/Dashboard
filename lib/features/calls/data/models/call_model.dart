class CallUser {
  final String id;
  final String fullName;
  final String? phone;

  CallUser({
    required this.id,
    required this.fullName,
    this.phone,
  });

  factory CallUser.fromJson(Map<String, dynamic> json) {
    return CallUser(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      phone: json['phone'],
    );
  }
}

class CallAdmin {
  final String id;
  final String fullName;

  CallAdmin({
    required this.id,
    required this.fullName,
  });

  factory CallAdmin.fromJson(Map<String, dynamic> json) {
    return CallAdmin(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
    );
  }
}

class CallModel {
  final String id;
  final String userId;
  final String number;
  final DateTime date;
  final String? adminId;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final CallUser? user;
  final CallAdmin? admin;

  CallModel({
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

  factory CallModel.fromJson(Map<String, dynamic> json) {
    return CallModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      number: json['number'] ?? '',
      date: DateTime.parse(json['date']),
      adminId: json['admin_id'],
      status: json['status'] ?? 'PENDING',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      user: json['user'] != null ? CallUser.fromJson(json['user']) : null,
      admin: json['admin'] != null ? CallAdmin.fromJson(json['admin']) : null,
    );
  }
}

class CallPaginationModel {
  final List<CallModel> calls;
  final int total;
  final int page;
  final int limit;

  CallPaginationModel({
    required this.calls,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory CallPaginationModel.fromJson(Map<String, dynamic> json) {
    return CallPaginationModel(
      calls: (json['calls'] as List).map((e) => CallModel.fromJson(e)).toList(),
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
    );
  }
}
