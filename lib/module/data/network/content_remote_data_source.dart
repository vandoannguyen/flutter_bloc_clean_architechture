import 'package:baese_flutter_bloc/module/domain/repository/content_repository.dart';

// dùng getIt để hỗ trợ cho DI như Hilt @singleton  @factoryMethod
class ContentRemoteDataSource implements ContentRepository {
  @override
  Future getData() {
    throw UnimplementedError();
  }
}
