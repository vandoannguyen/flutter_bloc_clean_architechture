import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.g.dart';

/// User data model for JSON serialization.
/// 
/// This is the data layer representation of a user.
/// Use UserEntity in domain layer.
@JsonSerializable(explicitToJson: true)
class UserModel {
  final String id;
  final String email;
  final String? name;
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;

  UserModel({
    required this.id,
    required this.email,
    this.name,
    this.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

/// Extension to convert UserModel to UserEntity.
extension UserModelExtension on UserModel {
  /// Converts UserModel to UserEntity.
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      name: name,
      avatarUrl: avatarUrl,
    );
  }
}
