import 'package:freezed_annotation/freezed_annotation.dart';
import 'failures/failure.dart';

part 'result.freezed.dart';

/// Result type for handling success/failure scenarios.
/// 
/// This is a functional approach to error handling that avoids throwing exceptions.
/// Instead, operations return a Result that can be either Success or Failure.
/// 
/// Example:
/// ```dart
/// final result = await repository.login(email: email, password: password);
/// result.when(
///   success: (user) => print('Logged in: ${user.email}'),
///   failure: (failure) => print('Error: ${failure.message}'),
/// );
/// ```
@freezed
class Result<T> with _$Result<T> {
  const factory Result.success(T data) = Success<T>;
  const factory Result.failure(Failure failure) = FailureResult<T>;
}

/// Extension methods for Result type.
extension ResultExtension<T> on Result<T> {
  /// Pattern matching for Result.
  /// 
  /// Executes [success] callback if Result is Success,
  /// or [failure] callback if Result is Failure.
  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) {
    return switch (this) {
      Success<T>(:final data) => success(data),
      FailureResult<T>(:final failure) => failure(failure),
    };
  }

  /// Returns true if Result is Success.
  bool get isSuccess => this is Success<T>;

  /// Returns true if Result is Failure.
  bool get isFailure => this is FailureResult<T>;

  /// Returns data if Success, null otherwise.
  T? get dataOrNull => when(
        success: (data) => data,
        failure: (_) => null,
      );

  /// Returns failure if Failure, null otherwise.
  Failure? get failureOrNull => when(
        success: (_) => null,
        failure: (failure) => failure,
      );

  /// Maps the success value to another type.
  Result<R> map<R>(R Function(T data) mapper) {
    return when(
      success: (data) => Result.success(mapper(data)),
      failure: (failure) => Result.failure(failure),
    );
  }

  /// Flat maps the Result to another Result.
  Result<R> flatMap<R>(Result<R> Function(T data) mapper) {
    return when(
      success: (data) => mapper(data),
      failure: (failure) => Result.failure(failure),
    );
  }
}
