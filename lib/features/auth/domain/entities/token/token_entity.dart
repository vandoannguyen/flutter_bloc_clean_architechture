/// Token domain entity.
/// 
/// This is a pure Dart class representing authentication tokens in the domain layer.
/// It has no dependencies on external frameworks or data sources.
/// 
/// Domain entities are the core business objects and should not contain
/// any framework-specific code or annotations.
class TokenEntity {
  final String? accessToken;
  final String? refreshToken;
  final int? expireAt;
  final String? tokenType;

  const TokenEntity({
    required this.accessToken,
    required this.refreshToken,
    this.expireAt,
    this.tokenType,
  });

  /// Checks if the access token is expired.
  /// 
  /// Returns true if expireAt is set and current time is past expiration.
  bool get isExpired {
    if (expireAt == null) return false;
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return now >= expireAt!;
  }

  /// Checks if the token is valid (not null and not expired).
  bool get isValid => accessToken != null && !isExpired;

  /// Creates a copy of this entity with updated fields.
  /// 
  /// All parameters are optional. If not provided, the original value is kept.
  TokenEntity copyWith({
    String? accessToken,
    String? refreshToken,
    int? expireAt,
    String? tokenType,
  }) {
    return TokenEntity(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expireAt: expireAt ?? this.expireAt,
      tokenType: tokenType ?? this.tokenType,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TokenEntity &&
          runtimeType == other.runtimeType &&
          accessToken == other.accessToken &&
          refreshToken == other.refreshToken;

  @override
  int get hashCode => accessToken.hashCode ^ refreshToken.hashCode;

  @override
  String toString() {
    return 'TokenEntity(accessToken: ${accessToken != null ? '***' : null}, '
        'refreshToken: ${refreshToken != null ? '***' : null}, '
        'expireAt: $expireAt, tokenType: $tokenType)';
  }
}
