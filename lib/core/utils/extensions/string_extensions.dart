/// Extension methods for [String] to provide convenient validation and manipulation.
extension StringExtensions on String {
  /// Validates if the string is a valid email address.
  /// 
  /// Uses regex pattern to check email format.
  /// Returns `true` if the email format is valid, `false` otherwise.
  /// 
  /// Example:
  /// ```dart
  /// 'user@example.com'.isValidEmail // true
  /// 'invalid-email'.isValidEmail // false
  /// ```
  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }

  /// Validates if the string is a valid password.
  /// 
  /// Currently checks for minimum length of 8 characters.
  /// You can extend this to include other requirements like:
  /// - Uppercase letters
  /// - Lowercase letters
  /// - Numbers
  /// - Special characters
  /// 
  /// Returns `true` if password meets requirements, `false` otherwise.
  bool get isValidPassword {
    return length >= 8;
  }

  /// Validates if the string is a valid Vietnamese phone number.
  /// 
  /// Accepts formats:
  /// - `0xxxxxxxxx` (10 digits starting with 0)
  /// - `+84xxxxxxxxx` (international format)
  /// 
  /// Returns `true` if the phone number format is valid, `false` otherwise.
  /// 
  /// Example:
  /// ```dart
  /// '0912345678'.isValidPhoneNumber // true
  /// '+84912345678'.isValidPhoneNumber // true
  /// '1234567890'.isValidPhoneNumber // false
  /// ```
  bool get isValidPhoneNumber {
    return RegExp(r'^(0|\+84)[1-9][0-9]{8,9}$').hasMatch(this);
  }

  /// Capitalizes the first letter of the string.
  /// 
  /// Returns a new string with the first character uppercase and the rest unchanged.
  /// If the string is empty, returns the original string.
  /// 
  /// Example:
  /// ```dart
  /// 'hello world'.capitalize // 'Hello world'
  /// 'HELLO'.capitalize // 'HELLO'
  /// ''.capitalize // ''
  /// ```
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Removes all whitespace characters from the string.
  /// 
  /// This includes spaces, tabs, newlines, etc.
  /// Returns a new string with all whitespace removed.
  /// 
  /// Example:
  /// ```dart
  /// 'hello world'.removeWhitespace // 'helloworld'
  /// '  test  '.removeWhitespace // 'test'
  /// ```
  String get removeWhitespace {
    return replaceAll(RegExp(r'\s+'), '');
  }

  /// Checks if the string represents a valid numeric value.
  /// 
  /// Returns `true` if the string can be parsed as a number (int or double),
  /// `false` otherwise.
  /// 
  /// Example:
  /// ```dart
  /// '123'.isNumeric // true
  /// '123.45'.isNumeric // true
  /// 'abc'.isNumeric // false
  /// '12.34.56'.isNumeric // false
  /// ```
  bool get isNumeric {
    return double.tryParse(this) != null;
  }
}
