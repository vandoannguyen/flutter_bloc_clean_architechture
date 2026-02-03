/// Form validation utilities.
/// 
/// These validators can be used in BLoC or Form widgets for input validation.
class FormValidators {
  /// Validates email format.
  /// 
  /// Returns null if valid, error message if invalid.
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Invalid email format';
    }
    
    return null;
  }

  /// Validates password.
  /// 
  /// [minLength] - Minimum password length (default: 8)
  /// Returns null if valid, error message if invalid.
  static String? password(String? value, {int minLength = 8}) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < minLength) {
      return 'Password must be at least $minLength characters';
    }
    
    return null;
  }

  /// Validates required field.
  /// 
  /// [fieldName] - Name of the field for error message
  /// Returns null if valid, error message if invalid.
  static String? required(String? value, {String fieldName = 'Field'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validates minimum length.
  /// 
  /// [minLength] - Minimum length required
  /// [fieldName] - Name of the field for error message
  /// Returns null if valid, error message if invalid.
  static String? minLength(
    String? value, {
    required int minLength,
    String fieldName = 'Field',
  }) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    
    if (value.length < minLength) {
      return '$fieldName must be at least $minLength characters';
    }
    
    return null;
  }

  /// Validates maximum length.
  /// 
  /// [maxLength] - Maximum length allowed
  /// [fieldName] - Name of the field for error message
  /// Returns null if valid, error message if invalid.
  static String? maxLength(
    String? value, {
    required int maxLength,
    String fieldName = 'Field',
  }) {
    if (value == null || value.isEmpty) {
      return null; // Empty is handled by required validator
    }
    
    if (value.length > maxLength) {
      return '$fieldName must be at most $maxLength characters';
    }
    
    return null;
  }

  /// Validates that two values match.
  /// 
  /// Used for password confirmation, etc.
  /// Returns null if valid, error message if invalid.
  static String? match(
    String? value,
    String? otherValue, {
    String fieldName = 'Field',
  }) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    
    if (value != otherValue) {
      return '$fieldName does not match';
    }
    
    return null;
  }

  /// Validates phone number format.
  /// 
  /// Returns null if valid, error message if invalid.
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    
    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
    
    if (!phoneRegex.hasMatch(value)) {
      return 'Invalid phone number format';
    }
    
    return null;
  }

  /// Validates URL format.
  /// 
  /// Returns null if valid, error message if invalid.
  static String? url(String? value) {
    if (value == null || value.isEmpty) {
      return 'URL is required';
    }
    
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    
    if (!urlRegex.hasMatch(value)) {
      return 'Invalid URL format';
    }
    
    return null;
  }
}
