// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:baese_flutter_bloc/common/utils/network/dio_client.dart'
    as _i14;
import 'package:baese_flutter_bloc/module/data/network/auth_remote_data_source.dart'
    as _i4;
import 'package:baese_flutter_bloc/module/data/network/content_remote_data_source.dart'
    as _i5;
import 'package:baese_flutter_bloc/module/data/repository/auth_repository_impl.dart'
    as _i12;
import 'package:baese_flutter_bloc/module/data/repository/content_repository_impl.dart'
    as _i7;
import 'package:baese_flutter_bloc/module/domain/repository/auth_repository.dart'
    as _i11;
import 'package:baese_flutter_bloc/module/domain/repository/content_repository.dart'
    as _i6;
import 'package:baese_flutter_bloc/module/domain/usecase/auth_usecase.dart'
    as _i13;
import 'package:baese_flutter_bloc/module/domain/usecase/content_usecase.dart'
    as _i8;
import 'package:baese_flutter_bloc/module/presenstation/bloc/app/app_bloc.dart'
    as _i3;
import 'package:baese_flutter_bloc/module/presenstation/bloc/main/main_view_bloc.dart'
    as _i10;
import 'package:baese_flutter_bloc/module/presenstation/bloc/main2/main2_bloc.dart'
    as _i9;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

extension GetItInjectableX on _i1.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.singleton<_i3.AppBloc>(_i3.AppBloc());
    gh.singleton<_i4.AuthRemoteDataSource>(_i4.AuthRemoteDataSource());
    gh.singleton<_i5.ContentRemoteDataSource>(_i5.ContentRemoteDataSource());
    gh.singleton<_i6.ContentRepository>(
        _i7.ContentRepositoryImpl(gh<_i5.ContentRemoteDataSource>()));
    gh.factory<_i8.ContentUseCase>(
        () => _i8.ContentUseCase(gh<_i6.ContentRepository>()));
    gh.factory<_i9.Main2Bloc>(() => _i9.Main2Bloc(gh<_i8.ContentUseCase>()));
    gh.factory<_i10.MainBloc>(() => _i10.MainBloc(gh<_i8.ContentUseCase>()));
    gh.singleton<_i11.AuthRepository>(
        _i12.AuthRepositoryImpl(gh<_i5.ContentRemoteDataSource>()));
    gh.factory<_i13.AuthUseCase>(
        () => _i13.AuthUseCase(gh<_i11.AuthRepository>()));
    gh.factory<_i14.DioClient>(() => _i14.DioClient(gh<_i13.AuthUseCase>()));
    return this;
  }
}
