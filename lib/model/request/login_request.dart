import 'package:freezed_annotation/freezed_annotation.dart';
part 'login_request.g.dart';
@JsonSerializable()
class LoginRequest{
  @JsonKey(name: "username")
  final String userName;
  final String password;

  LoginRequest(this.userName, this.password);
  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}