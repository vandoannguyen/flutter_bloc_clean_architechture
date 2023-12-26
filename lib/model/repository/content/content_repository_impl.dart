import 'package:base_flutter_bloc/model/request/login_request.dart';
import 'package:base_flutter_bloc/model/request/refresh_token_request.dart';
import 'package:injectable/injectable.dart';

import '../../local/content/content_local.dart';
import '../../network/content/content_network.dart';
import 'content_repository.dart';

@Injectable(as: ContentRepository)
class ContentRepositoryImpl extends ContentRepository {
  ContentLocal _contentLocal;
  ContentNetwork _contentNetwork;

  @factoryMethod
  ContentRepositoryImpl(this._contentLocal, this._contentNetwork);

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
