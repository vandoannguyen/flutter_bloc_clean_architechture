/// Mixin for states that use a status enum pattern.
/// 
/// This mixin provides common status-related functionality for states
/// that follow the status-based state management pattern.
/// 
/// Usage:
/// ```dart
/// enum MyStatus { initial, loading, success, error }
/// 
/// @Freezed(equal: true)
/// class MyState extends BaseDataStateCubit with _$MyState, StatusStateMixin {
///   factory MyState({
///     @Default(MyStatus.initial) MyStatus status,
///     // ... other fields
///   }) = _MyState;
/// }
/// 
/// // Then use:
/// state.isLoading // true if status == MyStatus.loading
/// state.isSuccess // true if status == MyStatus.success
/// ```
mixin StatusStateMixin {
  /// Gets the status value (must be implemented by the state)
  dynamic get status;

  /// Checks if the state is in initial status
  bool get isInitial => status.toString().contains('initial');

  /// Checks if the state is in loading status
  bool get isLoading => status.toString().contains('loading');

  /// Checks if the state is in success status
  bool get isSuccess => status.toString().contains('success');

  /// Checks if the state is in error status
  bool get isError => status.toString().contains('error');

  /// Checks if the state is in refreshing status
  bool get isRefreshing => status.toString().contains('refreshing');
}

/// Extension to provide status checking methods for any state.
/// 
/// This is a more flexible approach that doesn't require mixin.
extension StatusStateExtension on dynamic {
  /// Checks if status contains the given string
  bool hasStatus(String statusString) {
    return toString().toLowerCase().contains(statusString.toLowerCase());
  }
}
