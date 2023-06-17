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
    // TODO: implement getData
    throw UnimplementedError();
  }
}
