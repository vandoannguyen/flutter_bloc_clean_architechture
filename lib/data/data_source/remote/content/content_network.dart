import 'package:base_flutter_bloc/data/models/login_request/login_request.dart';
import 'package:base_flutter_bloc/data/models/refresh_token_request/refresh_token_request.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'content_network.g.dart';

@injectable
@RestApi()
abstract class ContentNetwork {
  @factoryMethod
  factory ContentNetwork(Dio dio) = _ContentNetwork;

  @GET("/users")
  Future<dynamic> getData();

  @POST("/login")
  Future<dynamic> login(@Body() LoginRequest body);

  @POST("/token")
  Future<dynamic> token(@Body() RefreshTokenRequest token);
}
