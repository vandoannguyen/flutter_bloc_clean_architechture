import 'package:base_flutter_bloc/data/data_source/remote/content/content_network.dart';
import 'package:base_flutter_bloc/data/models/login_request/login_request.dart';
import 'package:base_flutter_bloc/data/models/refresh_token_request/refresh_token_request.dart';
import 'package:base_flutter_bloc/domain/repositories/content_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ContentRepository)
class ContentRepositoryImpl extends ContentRepository {
  final ContentNetwork _contentNetwork;

  @factoryMethod
  ContentRepositoryImpl(this._contentNetwork);

  @override
  Future getData() {
    return _contentNetwork.getData();
  }

  @override
  Future login(LoginRequest body) {
    return _contentNetwork.login(body);
  }

  @override
  Future token(RefreshTokenRequest token) {
    // TODO: implement token
    throw UnimplementedError();
  }
}
