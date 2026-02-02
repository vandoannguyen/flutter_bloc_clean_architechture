import 'package:freezed_annotation/freezed_annotation.dart';
import 'failures/failure.dart';

part 'result.freezed.dart';

/// A Result type that represents either a success or a failure.
/// 
/// This is a functional programming pattern that provides type-safe error handling
/// without using exceptions. Instead of throwing exceptions, functions return
/// `Result<T>` which can be either `Success<T>` or `FailureResult<T>`.
/// 
/// Benefits:
/// - Type-safe error handling
/// - Compile-time error checking
/// - No need for try-catch blocks everywhere
/// - Explicit error handling in function signatures
/// 
/// Usage example:
/// ```dart
/// Future<Result<User>> login(String email, String password) async {
///   try {
///     final user = await api.login(email, password);
///     return Result.success(user);
///   } catch (e) {
///     return Result.failure(Failure.network(message: e.toString()));
///   }
/// }
/// 
/// final result = await login('email', 'password');
/// result.when(
///   success: (user) => print('Logged in: ${user.name}'),
///   failure: (failure) => print('Error: ${failure.message}'),
/// );
/// ```
@freezed
class Result<T> with _$Result<T> {
  /// Creates a successful result with [data]
  const factory Result.success(T data) = Success<T>;
  
  /// Creates a failed result with [failure]
  const factory Result.failure(Failure failure) = FailureResult<T>;
}

/// Extension methods for [Result] to provide convenient operations.
extension ResultExtension<T> on Result<T> {
  /// Pattern matching to handle success and failure cases.
  /// 
  /// This is the primary way to extract values from a Result.
  /// Both callbacks are required to ensure all cases are handled.
  /// 
  /// [success] - Callback executed when result is successful, receives the data
  /// [failure] - Callback executed when result is a failure, receives the failure
  /// 
  /// Returns the result of the executed callback.
  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) {
    return switch (this) {
      Success<T>(:final data) => success(data),
      FailureResult<T>(:final failure) => failure(failure),
    };
  }

  /// Returns `true` if this result is a success.
  bool get isSuccess => this is Success<T>;
  
  /// Returns `true` if this result is a failure.
  bool get isFailure => this is FailureResult<T>;
  
  /// Returns the data if successful, `null` otherwise.
  /// 
  /// Use this when you want to safely extract the value without handling
  /// the failure case explicitly.
  T? get dataOrNull => when(
    success: (data) => data,
    failure: (_) => null,
  );

  /// Returns the failure if present, `null` otherwise.
  /// 
  /// Use this when you want to safely extract the failure without handling
  /// the success case explicitly.
  Failure? get failureOrNull => when(
    success: (_) => null,
    failure: (failure) => failure,
  );

  /// Transforms the success value to a different type.
  /// 
  /// If this result is a success, applies [mapper] to the data and returns
  /// a new success result. If this result is a failure, returns a new
  /// failure result with the same failure.
  /// 
  /// [mapper] - Function to transform the success value
  /// 
  /// Example:
  /// ```dart
  /// Result<int> result = Result.success(5);
  /// Result<String> mapped = result.map((value) => value.toString());
  /// // Returns Result.success("5")
  /// ```
  Result<R> map<R>(R Function(T) mapper) {
    return when(
      success: (data) => Result.success(mapper(data)),
      failure: (failure) => Result.failure(failure),
    );
  }

  /// Chains multiple Results together (monadic bind).
  /// 
  /// If this result is a success, applies [mapper] to the data and returns
  /// its result. If this result is a failure, returns a new failure result
  /// with the same failure.
  /// 
  /// This is useful for chaining async operations that return Results.
  /// 
  /// [mapper] - Function that takes the success value and returns a Future Result
  /// 
  /// Example:
  /// ```dart
  /// final result = await login('email', 'password')
  ///   .flatMap((user) => getUserProfile(user.id));
  /// ```
  Future<Result<R>> flatMap<R>(Future<Result<R>> Function(T) mapper) async {
    return when(
      success: (data) => await mapper(data),
      failure: (failure) => Result.failure(failure),
    );
  }
}
