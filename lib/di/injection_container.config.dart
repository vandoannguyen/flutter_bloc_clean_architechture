// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../module/data/network/content_remote_data_source.dart' as _i7;
import '../module/data/repository/content_repository_impl.dart' as _i8;
import '../module/domain/repository/content_repository.dart' as _i4;
import '../module/domain/usecase/content_usecase.dart' as _i3;
import '../module/presenstation/bloc/main/main_view_bloc.dart' as _i6;
import '../module/presenstation/bloc/main2/main2_bloc.dart'
    as _i5; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.factory<_i3.ContentUseCase>(
      () => _i3.ContentUseCase(get<_i4.ContentRepository>()));
  gh.factory<_i5.Main2Bloc>(() => _i5.Main2Bloc(get<_i3.ContentUseCase>()));
  gh.factory<_i6.MainBloc>(() => _i6.MainBloc(get<_i3.ContentUseCase>()));
  gh.singleton<_i7.ContentRemoteDataSource>(_i7.ContentRemoteDataSource());
  gh.singleton<_i4.ContentRepository>(
      _i8.ContentRepositoryImpl(get<_i7.ContentRemoteDataSource>()));
  return get;
}
