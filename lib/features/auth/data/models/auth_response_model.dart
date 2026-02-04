class AuthResponseModel {
  final String? accessToken;
  final String? refreshToken;
  // Add other user fields if needed based on typical response

  AuthResponseModel({this.accessToken, this.refreshToken});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }
}
