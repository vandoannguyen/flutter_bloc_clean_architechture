import 'package:baese_flutter_bloc/module/domain/repository/content_repository.dart';
import 'package:injectable/injectable.dart';

@singleton
class ContentRemoteDataSource implements ContentRepository {
  @override
  Future getData() {
    throw UnimplementedError();
  }

  @factoryMethod
  ContentRemoteDataSource();
}
