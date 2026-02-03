/// Extension methods for String type.
extension StringExtensions on String {
  /// Validates if the string is a valid email address.
  bool get isValidEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  /// Validates if the string is a valid password.
  /// 
  /// Password must be at least 8 characters long.
  bool get isValidPassword {
    return length >= 8;
  }

  /// Capitalizes the first letter of the string.
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Checks if the string is not empty.
  bool get isNotEmpty => this != '';

  /// Checks if the string is empty or contains only whitespace.
  bool get isBlank => trim().isEmpty;
}
