/// Core module exports
/// 
/// This file exports all core functionality for easy importing.
/// 
/// Usage:
/// ```dart
/// import 'package:base_flutter_bloc/core/index.dart';
/// ```

// Error handling
export 'error/result.dart';
export 'error/failures/failure.dart';
export 'error/exceptions/business_exception.dart';
export 'error/exceptions/network_exception.dart';
export 'error/exceptions/server_exception.dart';

// Network
export 'network/dio_client.dart';
export 'network/url_config.dart';
export 'network/multipart_file_extended.dart';

// BLoC
export 'bloc/enhanced_base_cubit.dart';
export 'bloc/state_helpers.dart';
export 'bloc/status_state_mixin.dart';

// Utils
export 'utils/debouncer.dart';
export 'utils/extensions/build_context_extensions.dart';
export 'utils/extensions/string_extensions.dart';
export 'utils/validators/validators.dart';
export 'utils/logger.dart';

// Constants
export 'constants/app_constants.dart';

// Dependency Injection
export 'di/injection_container.dart';
export 'di/modules.dart';
