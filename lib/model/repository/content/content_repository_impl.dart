import 'package:baese_flutter_bloc/module/model/local/content/content_local.dart';
import 'package:baese_flutter_bloc/module/model/network/content/content_network.dart';
import 'package:injectable/injectable.dart';

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
