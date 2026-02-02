import 'dart:async';

/// A debouncer that delays the execution of a callback function.
/// 
/// Useful for scenarios where you want to limit the frequency of function calls,
/// such as:
/// - Search input: Wait for user to stop typing before searching
/// - Auto-save: Save after user stops editing
/// - API calls: Prevent excessive API requests
/// - Button clicks: Prevent accidental double-clicks
/// 
/// The debouncer will cancel any pending callbacks and start a new timer
/// each time [call] is invoked. The callback will only execute after the
/// specified delay has passed without any new calls.
/// 
/// Usage example:
/// ```dart
/// final debouncer = Debouncer(delay: Duration(milliseconds: 500));
/// 
/// // In TextField's onChanged:
/// onChanged: (value) {
///   debouncer.call(() {
///     search(value);
///   });
/// }
/// 
/// // Don't forget to dispose:
/// @override
/// void dispose() {
///   debouncer.dispose();
///   super.dispose();
/// }
/// ```
class Debouncer {
  /// The delay duration before executing the callback
  final Duration delay;
  
  /// Internal timer that tracks the pending callback
  Timer? _timer;

  /// Creates a new debouncer with the specified delay.
  /// 
  /// [delay] - The duration to wait before executing the callback.
  ///           Defaults to 500 milliseconds.
  Debouncer({this.delay = const Duration(milliseconds: 500)});

  /// Schedules a callback to be executed after the delay.
  /// 
  /// If a callback is already pending, it will be cancelled and a new
  /// timer will be started. This ensures only the last callback executes.
  /// 
  /// [callback] - The function to execute after the delay
  void call(VoidCallback callback) {
    _timer?.cancel();
    _timer = Timer(delay, callback);
  }

  /// Cancels the currently pending callback.
  /// 
  /// If no callback is pending, this method does nothing.
  void cancel() {
    _timer?.cancel();
  }

  /// Disposes the debouncer and cancels any pending callbacks.
  /// 
  /// Call this method when the debouncer is no longer needed to prevent
  /// memory leaks. Typically called in a widget's dispose method.
  void dispose() {
    _timer?.cancel();
  }
}
