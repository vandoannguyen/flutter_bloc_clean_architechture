import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

/// Base Failure class representing all types of errors in the application.
/// 
/// Uses Freezed for pattern matching and immutability. This provides a
/// type-safe way to represent different error types without using exceptions.
/// 
/// Each failure type represents a specific category of errors:
/// - [ServerFailure]: Server-side errors (500, 404, etc.)
/// - [NetworkFailure]: Network-related errors (timeout, no internet, etc.)
/// - [ValidationFailure]: Input validation errors
/// - [UnauthorizedFailure]: Authentication/authorization errors (401)
/// - [CacheFailure]: Local storage/cache errors
/// - [UnknownFailure]: Unexpected or unhandled errors
/// 
/// Usage example:
/// ```dart
/// if (response.statusCode == 500) {
///   return Failure.server(
///     message: 'Internal server error',
///     statusCode: 500,
///   );
/// }
/// ```
@freezed
class Failure with _$Failure {
  /// Server-side error (500, 404, etc.)
  /// 
  /// [message] - Human-readable error message
  /// [statusCode] - HTTP status code (if applicable)
  /// [error] - Original error object (optional)
  const factory Failure.server({
    required String message,
    int? statusCode,
    dynamic error,
  }) = ServerFailure;
  
  /// Network-related error (timeout, no internet, etc.)
  /// 
  /// [message] - Human-readable error message
  const factory Failure.network({
    required String message,
  }) = NetworkFailure;
  
  /// Input validation error
  /// 
  /// [message] - Human-readable error message describing the validation failure
  const factory Failure.validation({
    required String message,
  }) = ValidationFailure;
  
  /// Unauthorized error (401)
  /// 
  /// Typically used when authentication fails or token is invalid.
  /// [message] - Human-readable error message
  const factory Failure.unauthorized({
    required String message,
  }) = UnauthorizedFailure;
  
  /// Local storage/cache error
  /// 
  /// Used when reading from or writing to local storage fails.
  /// [message] - Human-readable error message
  const factory Failure.cache({
    required String message,
  }) = CacheFailure;
  
  /// Unknown or unhandled error
  /// 
  /// Used as a fallback for unexpected errors that don't fit other categories.
  /// [message] - Human-readable error message
  const factory Failure.unknown({
    required String message,
  }) = UnknownFailure;
}

/// Extension methods for [Failure] to provide convenient operations.
extension FailureExtension on Failure {
  /// Extracts the error message from any failure type.
  /// 
  /// This is a convenience getter that uses pattern matching to extract
  /// the message regardless of the failure type.
  String get message => when(
    server: (message, _, __) => message,
    network: (message) => message,
    validation: (message) => message,
    unauthorized: (message) => message,
    cache: (message) => message,
    unknown: (message) => message,
  );

  /// Returns `true` if this is a network error.
  bool get isNetworkError => this is NetworkFailure;
  
  /// Returns `true` if this is a server error.
  bool get isServerError => this is ServerFailure;
  
  /// Returns `true` if this is a validation error.
  bool get isValidationError => this is ValidationFailure;
  
  /// Returns `true` if this is an unauthorized error.
  bool get isUnauthorizedError => this is UnauthorizedFailure;
  
  /// Returns `true` if this is a cache error.
  bool get isCacheError => this is CacheFailure;
}
