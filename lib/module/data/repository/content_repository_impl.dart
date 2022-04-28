import 'package:baese_flutter_bloc/module/data/network/content_remote_data_source.dart';
import 'package:baese_flutter_bloc/module/domain/repository/content_repository.dart';
import 'package:injectable/injectable.dart';

// dùng getIt để hỗ trợ cho DI như Hilt @singleton  @factoryMethod
@Singleton(as: ContentRepository)
class ContentRepositoryImpl implements ContentRepository {
  ContentRemoteDataSource dataSource;

  @factoryMethod
  ContentRepositoryImpl(this.dataSource);

  @override
  Future getData() {
    throw UnimplementedError();
  }
}
