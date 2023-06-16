import 'package:injectable/injectable.dart';

import 'content_network.dart';

@Injectable(as: ContentNetwork)
class ContentNetworkImpl implements ContentNetwork {
  @factoryMethod
  ContentNetworkImpl();

  @override
  Future getData() {
    // TODO: implement getData
    throw UnimplementedError();
  }
}
