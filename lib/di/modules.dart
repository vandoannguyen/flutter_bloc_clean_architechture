import 'package:base_flutter_bloc/core/network/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@module
abstract class RegisterModule {
  @singleton
  Dio get prefs => DioClient().getDefaultInstance();
}
