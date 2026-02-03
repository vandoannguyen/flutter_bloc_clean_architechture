import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

/// Base failure type for error handling.
/// 
/// This represents different types of failures that can occur in the application.
/// Using a sealed class ensures type safety and exhaustive pattern matching.
@freezed
class Failure with _$Failure {
  /// Server error (4xx, 5xx responses).
  const factory Failure.server({
    required String message,
    int? statusCode,
    dynamic error,
  }) = ServerFailure;

  /// Network error (timeout, no internet, etc.).
  const factory Failure.network({
    required String message,
  }) = NetworkFailure;

  /// Validation error (invalid input).
  const factory Failure.validation({
    required String message,
  }) = ValidationFailure;

  /// Authentication error (unauthorized, token expired).
  const factory Failure.authentication({
    required String message,
  }) = AuthenticationFailure;

  /// Unknown/unexpected error.
  const factory Failure.unknown({
    required String message,
    dynamic error,
  }) = UnknownFailure;
}

/// Extension methods for Failure.
extension FailureExtension on Failure {
  /// Returns the error message.
  String get message => when(
        server: (message, _, __) => message,
        network: (message) => message,
        validation: (message) => message,
        authentication: (message) => message,
        unknown: (message, _) => message,
      );

  /// Returns true if this is a validation error.
  bool get isValidationError => this is ValidationFailure;

  /// Returns true if this is a network error.
  bool get isNetworkError => this is NetworkFailure;

  /// Returns true if this is an authentication error.
  bool get isAuthenticationError => this is AuthenticationFailure;
}
