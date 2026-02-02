import '../extensions/string_extensions.dart';

/// A collection of static validation methods for form inputs.
/// 
/// These validators follow Flutter's FormField validator pattern:
/// - Return `null` if validation passes
/// - Return `String` error message if validation fails
/// 
/// Usage example:
/// ```dart
/// TextFormField(
///   validator: Validators.email,
/// )
/// ```
class Validators {
  /// Validates an email address.
  /// 
  /// Returns `null` if valid, otherwise returns an error message.
  /// Checks for:
  /// - Non-empty value
  /// - Valid email format using regex
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }
    if (!value.isValidEmail) {
      return 'Invalid email format';
    }
    return null;
  }

  /// Validates a password.
  /// 
  /// Returns `null` if valid, otherwise returns an error message.
  /// Checks for:
  /// - Non-empty value
  /// - Minimum length of 8 characters
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    if (!value.isValidPassword) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  /// Validates a password confirmation field.
  /// 
  /// Returns `null` if valid, otherwise returns an error message.
  /// Checks for:
  /// - Non-empty value
  /// - Match with the original password
  /// 
  /// [value] - The confirmation password value
  /// [password] - The original password to match against
  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Password confirmation cannot be empty';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Validates a phone number (Vietnamese format).
  /// 
  /// Returns `null` if valid, otherwise returns an error message.
  /// Checks for:
  /// - Non-empty value
  /// - Valid Vietnamese phone number format (0xxxxxxxxx or +84xxxxxxxxx)
  static String? phoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number cannot be empty';
    }
    if (!value.isValidPhoneNumber) {
      return 'Invalid phone number format';
    }
    return null;
  }

  /// Validates that a field is required (non-empty).
  /// 
  /// Returns `null` if valid, otherwise returns an error message.
  /// 
  /// [value] - The value to validate
  /// [fieldName] - Optional custom field name for error message
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} cannot be empty';
    }
    return null;
  }

  /// Validates minimum length of a string.
  /// 
  /// Returns `null` if valid, otherwise returns an error message.
  /// Checks for:
  /// - Non-empty value
  /// - Minimum length requirement
  /// 
  /// [value] - The value to validate
  /// [minLength] - Minimum required length
  /// [fieldName] - Optional custom field name for error message
  static String? minLength(String? value, int minLength, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} cannot be empty';
    }
    if (value.length < minLength) {
      return '${fieldName ?? 'This field'} must be at least $minLength characters';
    }
    return null;
  }

  /// Validates maximum length of a string.
  /// 
  /// Returns `null` if valid, otherwise returns an error message.
  /// 
  /// [value] - The value to validate (can be null)
  /// [maxLength] - Maximum allowed length
  /// [fieldName] - Optional custom field name for error message
  static String? maxLength(String? value, int maxLength, {String? fieldName}) {
    if (value != null && value.length > maxLength) {
      return '${fieldName ?? 'This field'} cannot exceed $maxLength characters';
    }
    return null;
  }
}
