/// Application-wide constants.
/// 
/// This class contains all static constants used throughout the application.
/// Using a single class for constants helps maintain consistency and makes
/// it easier to update values that are used in multiple places.
/// 
/// The private constructor prevents instantiation, ensuring this class
/// is only used for accessing static constants.
/// 
/// Usage example:
/// ```dart
/// final timeout = AppConstants.connectTimeout;
/// final key = AppConstants.tokenKey;
/// ```
class AppConstants {
  /// Private constructor to prevent instantiation.
  /// 
  /// This ensures the class can only be used for accessing static constants.
  AppConstants._();

  // ============================================================================
  // API Configuration
  // ============================================================================

  /// Connection timeout for API requests in milliseconds.
  /// Default: 30 seconds
  static const int connectTimeout = 30000;

  /// Receive timeout for API requests in milliseconds.
  /// Default: 30 seconds
  static const int receiveTimeout = 30000;

  /// Send timeout for API requests in milliseconds.
  /// Default: 30 seconds
  static const int sendTimeout = 30000;

  // ============================================================================
  // Storage Keys
  // ============================================================================

  /// Key for storing authentication token in local storage.
  static const String tokenKey = 'auth_token';

  /// Key for storing refresh token in local storage.
  static const String refreshTokenKey = 'refresh_token';

  /// Key for storing user data in local storage.
  static const String userKey = 'user_data';

  /// Key for storing theme mode preference in local storage.
  static const String themeKey = 'theme_mode';

  /// Key for storing language preference in local storage.
  static const String languageKey = 'language';

  // ============================================================================
  // Pagination
  // ============================================================================

  /// Default number of items per page for paginated lists.
  static const int defaultPageSize = 20;

  /// Maximum number of items per page for paginated lists.
  static const int maxPageSize = 100;

  // ============================================================================
  // Validation Rules
  // ============================================================================

  /// Minimum required length for passwords.
  static const int minPasswordLength = 8;

  /// Maximum allowed length for passwords.
  static const int maxPasswordLength = 50;

  /// Minimum required length for usernames.
  static const int minUsernameLength = 3;

  /// Maximum allowed length for usernames.
  static const int maxUsernameLength = 30;

  // ============================================================================
  // Debounce Delays
  // ============================================================================

  /// Delay duration for search input debouncing.
  /// 
  /// Used to prevent excessive API calls while user is typing.
  static const Duration searchDebounceDelay = Duration(milliseconds: 500);

  /// Delay duration for auto-save functionality.
  /// 
  /// Used to prevent excessive save operations while user is editing.
  static const Duration autoSaveDebounceDelay = Duration(seconds: 2);

  // ============================================================================
  // Cache Configuration
  // ============================================================================

  /// Duration before cached data expires.
  /// 
  /// After this duration, cached data should be refreshed.
  static const Duration cacheExpiration = Duration(hours: 24);
}
