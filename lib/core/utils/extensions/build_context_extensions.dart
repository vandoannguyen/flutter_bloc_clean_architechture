import 'package:flutter/material.dart';

/// Extension methods for [BuildContext] to provide convenient access to
/// theme, media query, navigation, and UI utilities.
/// 
/// These extensions reduce boilerplate code and make common operations
/// more concise and readable.
/// 
/// Usage example:
/// ```dart
/// // Instead of: Theme.of(context).textTheme.headlineLarge
/// context.textTheme.headlineLarge
/// 
/// // Instead of: MediaQuery.of(context).size.width
/// context.screenWidth
/// 
/// // Instead of: ScaffoldMessenger.of(context).showSnackBar(...)
/// context.showErrorSnackBar('Error occurred');
/// ```
extension BuildContextExtensions on BuildContext {
  /// Gets the [ThemeData] from the nearest [Theme] ancestor.
  ThemeData get theme => Theme.of(this);
  
  /// Gets the [TextTheme] from the current theme.
  TextTheme get textTheme => theme.textTheme;
  
  /// Gets the [ColorScheme] from the current theme.
  ColorScheme get colorScheme => theme.colorScheme;
  
  /// Gets the [MediaQueryData] from the nearest [MediaQuery] ancestor.
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  
  /// Gets the screen size from MediaQuery.
  Size get screenSize => mediaQuery.size;
  
  /// Gets the screen width in logical pixels.
  double get screenWidth => screenSize.width;
  
  /// Gets the screen height in logical pixels.
  double get screenHeight => screenSize.height;
  
  /// Checks if the app is currently in dark mode.
  /// 
  /// Returns `true` if the theme brightness is dark, `false` otherwise.
  bool get isDarkMode => theme.brightness == Brightness.dark;
  
  /// Shows a snackbar with the given message.
  /// 
  /// [message] - The message to display
  /// [backgroundColor] - Optional background color for the snackbar.
  ///                    If not provided, uses the default theme color.
  void showSnackBar(String message, {Color? backgroundColor}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }
  
  /// Shows an error snackbar with red background.
  /// 
  /// Uses the error color from the current color scheme.
  /// 
  /// [message] - The error message to display
  void showErrorSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: colorScheme.error,
    );
  }
  
  /// Shows a success snackbar with green background.
  /// 
  /// [message] - The success message to display
  void showSuccessSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: Colors.green,
    );
  }
  
  /// Navigates to a named route.
  /// 
  /// Pushes a new route onto the navigator stack.
  /// 
  /// [routeName] - The name of the route to navigate to
  /// [arguments] - Optional arguments to pass to the route
  /// 
  /// Returns a Future that completes with the result value when the
  /// pushed route is popped off the navigator.
  Future<T?> navigateTo<T>(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed<T>(routeName, arguments: arguments);
  }
  
  /// Navigates to a named route and replaces the current route.
  /// 
  /// Removes the current route from the navigator stack and pushes
  /// the new route in its place.
  /// 
  /// [routeName] - The name of the route to navigate to
  /// [arguments] - Optional arguments to pass to the route
  /// 
  /// Returns a Future that completes with the result value when the
  /// new route is popped off the navigator.
  Future<T?> navigateReplacement<T>(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushReplacementNamed<T>(
      routeName,
      arguments: arguments,
    );
  }
  
  /// Pops the current route off the navigator stack.
  /// 
  /// [result] - Optional result value to return to the previous route
  void pop<T>([T? result]) {
    Navigator.of(this).pop(result);
  }
}
