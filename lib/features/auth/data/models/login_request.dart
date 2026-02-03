import 'package:json_annotation/json_annotation.dart';

part 'login_request.g.dart';

/// Login request model for API calls.
@JsonSerializable()
class LoginRequest {
  @JsonKey(name: "username")
  final String userName;
  final String password;

  LoginRequest(this.userName, this.password);

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
