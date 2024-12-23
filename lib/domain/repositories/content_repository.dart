import 'package:base_flutter_bloc/data/data_source/local/content/content_local.dart';
import 'package:base_flutter_bloc/data/data_source/remote/content/content_network.dart';
abstract class ContentRepository implements ContentLocal, ContentNetwork{

}
