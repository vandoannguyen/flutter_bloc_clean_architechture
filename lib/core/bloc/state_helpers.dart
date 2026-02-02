import 'package:base_bloc_module/base/cubit/base_data_state_cubit.dart';
import 'package:base_bloc_module/base/cubit/base_state_cubit.dart';

/// Helper functions for working with states.
/// 
/// Provides utility functions for common state operations and checks.
class StateHelpers {
  StateHelpers._();

  /// Checks if a state is a data state (not an event).
  /// 
  /// [state] - The state to check
  /// 
  /// Returns `true` if the state is a data state
  static bool isDataState(BaseStateCubit state) {
    return state is BaseDataStateCubit;
  }

  /// Checks if a state represents a loading state.
  /// 
  /// This checks common loading status patterns:
  /// - Status enum containing "loading"
  /// - isLoading boolean property
  /// 
  /// [state] - The state to check
  /// 
  /// Returns `true` if the state represents loading
  static bool isLoadingState(BaseStateCubit state) {
    if (state is BaseDataStateCubit) {
      // Check for status property
      try {
        final status = (state as dynamic).status;
        if (status != null) {
          return status.toString().toLowerCase().contains('loading');
        }
      } catch (_) {
        // No status property
      }

      // Check for isLoading property
      try {
        final isLoading = (state as dynamic).isLoading;
        if (isLoading is bool) {
          return isLoading;
        }
      } catch (_) {
        // No isLoading property
      }
    }
    return false;
  }

  /// Checks if a state represents an error state.
  /// 
  /// This checks common error patterns:
  /// - Status enum containing "error"
  /// - errorMessage property that is not null/empty
  /// 
  /// [state] - The state to check
  /// 
  /// Returns `true` if the state represents an error
  static bool isErrorState(BaseStateCubit state) {
    if (state is BaseDataStateCubit) {
      // Check for status property
      try {
        final status = (state as dynamic).status;
        if (status != null) {
          return status.toString().toLowerCase().contains('error');
        }
      } catch (_) {
        // No status property
      }

      // Check for errorMessage property
      try {
        final errorMessage = (state as dynamic).errorMessage;
        if (errorMessage != null && errorMessage.toString().isNotEmpty) {
          return true;
        }
      } catch (_) {
        // No errorMessage property
      }
    }
    return false;
  }

  /// Gets the error message from a state if it exists.
  /// 
  /// [state] - The state to extract error message from
  /// 
  /// Returns the error message or null if not found
  static String? getErrorMessage(BaseStateCubit state) {
    if (state is BaseDataStateCubit) {
      try {
        final errorMessage = (state as dynamic).errorMessage;
        if (errorMessage != null) {
          return errorMessage.toString();
        }
      } catch (_) {
        // No errorMessage property
      }
    }
    return null;
  }
}
