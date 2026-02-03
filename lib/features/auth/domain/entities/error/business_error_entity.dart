/// Business error domain entity.
/// 
/// This is a pure Dart class representing business errors in the domain layer.
/// It has no dependencies on external frameworks or data sources.
class BusinessErrorEntity {
  final int? code;
  final String? errorCode;
  final dynamic errorData;
  final String? errorMessage;

  const BusinessErrorEntity({
    this.code,
    this.errorCode,
    this.errorData,
    this.errorMessage,
  });

  /// Creates a copy of this entity with updated fields.
  BusinessErrorEntity copyWith({
    int? code,
    String? errorCode,
    dynamic errorData,
    String? errorMessage,
  }) {
    return BusinessErrorEntity(
      code: code ?? this.code,
      errorCode: errorCode ?? this.errorCode,
      errorData: errorData ?? this.errorData,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusinessErrorEntity &&
          runtimeType == other.runtimeType &&
          code == other.code &&
          errorCode == other.errorCode &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode => code.hashCode ^ errorCode.hashCode ^ errorMessage.hashCode;

  @override
  String toString() {
    return 'BusinessErrorEntity(code: $code, errorCode: $errorCode, '
        'errorMessage: $errorMessage)';
  }
}
