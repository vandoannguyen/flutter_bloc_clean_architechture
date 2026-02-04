import 'package:base_flutter_bloc/features/auth/data/models/login_request.dart';
import 'package:base_flutter_bloc/features/auth/data/models/refresh_token_request.dart';
import 'package:base_flutter_bloc/features/auth/data/models/user_model.dart' show UserModel;
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'auth_remote_datasource.g.dart';

/// Remote data source for authentication API calls.
@injectable
@RestApi()
abstract class AuthRemoteDataSource {
  @factoryMethod
  factory AuthRemoteDataSource(Dio dio) = _AuthRemoteDataSource;

  @POST("/login")
  Future login(@Body() LoginRequest request);

  @POST("/token")
  Future refreshToken(@Body() RefreshTokenRequest request);

  @GET("/users")
  Future<UserModel> getCurrentUser();
}
