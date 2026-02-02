import 'package:base_bloc_module/base/cubit/base_cubit.dart';
import 'package:base_bloc_module/base/cubit/base_cubit_event.dart';
import 'package:base_bloc_module/base/cubit/base_state_cubit.dart';
import 'package:base_bloc_module/models/message_model.dart';

/// Enhanced BaseCubit with improved loading and event management.
/// 
/// This extends the base BaseCubit with additional features:
/// - Stack-based loading management for concurrent operations
/// - Better event handling
/// - Type-safe navigation events
/// 
/// Usage:
/// ```dart
/// class MyBloc extends EnhancedBaseCubit<MyState> {
///   Future<void> loadData() async {
///     showLoading('loadData');
///     try {
///       final data = await repository.getData();
///       emit(state.copyWith(data: data));
///     } finally {
///       hideLoading('loadData');
///     }
///   }
/// }
/// ```
abstract class EnhancedBaseCubit<STATE extends BaseStateCubit>
    extends BaseCubit<STATE> {
  /// Set of active loading operation IDs
  /// Used to track multiple concurrent loading operations
  final Set<String> _loadingOperations = {};

  EnhancedBaseCubit(STATE initialState) : super(initialState);

  /// Shows loading indicator for a specific operation.
  /// 
  /// If [operationId] is provided, tracks this specific operation.
  /// Multiple operations can be loading simultaneously.
  /// 
  /// [operationId] - Optional identifier for the loading operation.
  ///                If not provided, uses a default identifier.
  void showLoading([String? operationId]) {
    final id = operationId ?? 'default';
    _loadingOperations.add(id);
    emit(OnLoadingEvent(true));
  }

  /// Hides loading indicator for a specific operation.
  /// 
  /// If [operationId] is provided, only hides loading for that operation.
  /// Loading will remain visible if other operations are still active.
  /// 
  /// [operationId] - Optional identifier for the loading operation.
  ///                If not provided, hides all loading operations.
  void hideLoading([String? operationId]) {
    if (operationId != null) {
      _loadingOperations.remove(operationId);
      if (_loadingOperations.isNotEmpty) {
        // Other operations are still loading, don't hide
        return;
      }
    } else {
      // Hide all operations
      _loadingOperations.clear();
    }
    emit(OnLoadingEvent(false));
  }

  /// Checks if any loading operation is currently active.
  bool get isLoading => _loadingOperations.isNotEmpty;

  /// Gets the list of active loading operation IDs.
  List<String> get activeLoadingOperations => _loadingOperations.toList();

  /// Shows a success message.
  /// 
  /// [message] - The success message to display
  void showSuccessMessage(String message) {
    showMessage(message, type: MessageType.success);
  }

  /// Shows an error message.
  /// 
  /// [message] - The error message to display
  void showErrorMessage(String message) {
    showMessage(message, type: MessageType.error);
  }

  /// Shows a warning message.
  /// 
  /// [message] - The warning message to display
  void showWarningMessage(String message) {
    showMessage(message, type: MessageType.waring);
  }

  /// Executes an async operation with automatic loading management.
  /// 
  /// Shows loading at the start and hides it when the operation completes
  /// (success or failure). Useful for wrapping API calls.
  /// 
  /// [operation] - The async operation to execute
  /// [operationId] - Optional identifier for the loading operation
  /// 
  /// Returns the result of the operation
  Future<T> executeWithLoading<T>(
    Future<T> Function() operation, {
    String? operationId,
  }) async {
    showLoading(operationId);
    try {
      return await operation();
    } finally {
      hideLoading(operationId);
    }
  }

  /// Executes multiple async operations concurrently with loading management.
  /// 
  /// Shows loading at the start and hides it when all operations complete.
  /// 
  /// [operations] - List of async operations to execute
  /// 
  /// Returns a list of results in the same order as operations
  Future<List<T>> executeAllWithLoading<T>(
    List<Future<T> Function()> operations,
  ) async {
    showLoading('batch');
    try {
      return await Future.wait(operations.map((op) => op()));
    } finally {
      hideLoading('batch');
    }
  }
}
