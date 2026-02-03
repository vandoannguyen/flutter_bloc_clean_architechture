/// User domain entity.
/// 
/// This is a pure Dart class representing a user in the domain layer.
/// It has no dependencies on external frameworks or data sources.
/// 
/// Domain entities are the core business objects and should not contain
/// any framework-specific code or annotations.
class UserEntity {
  final String id;
  final String email;
  final String? name;
  final String? avatarUrl;

  const UserEntity({
    required this.id,
    required this.email,
    this.name,
    this.avatarUrl,
  });

  /// Checks if the user has a valid email.
  bool get hasValidEmail => email.isNotEmpty && email.contains('@');

  /// Checks if the user has a name.
  bool get hasName => name != null && name!.isNotEmpty;

  /// Creates a copy of this entity with updated fields.
  /// 
  /// All parameters are optional. If not provided, the original value is kept.
  UserEntity copyWith({
    String? id,
    String? email,
    String? name,
    String? avatarUrl,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email;

  @override
  int get hashCode => id.hashCode ^ email.hashCode;

  @override
  String toString() {
    return 'UserEntity(id: $id, email: $email, name: $name)';
  }
}
