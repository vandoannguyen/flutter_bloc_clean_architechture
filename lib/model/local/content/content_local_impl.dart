import 'package:injectable/injectable.dart';

import 'content_local.dart';

@Injectable(as: ContentLocal)
class ContentLocalImpl extends ContentLocal {
  @factoryMethod
  ContentLocalImpl();
}
