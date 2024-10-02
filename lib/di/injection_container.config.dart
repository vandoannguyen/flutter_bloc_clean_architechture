// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:base_flutter_bloc/bloc/app/app_bloc.dart' as _i7;
import 'package:base_flutter_bloc/bloc/home/home_bloc.dart' as _i3;
import 'package:base_flutter_bloc/bloc/login/login_bloc.dart' as _i4;
import 'package:base_flutter_bloc/common/logger/logger.dart' as _i6;
import 'package:base_flutter_bloc/di/modules.dart' as _i13;
import 'package:base_flutter_bloc/model/local/content/content_local.dart'
    as _i8;
import 'package:base_flutter_bloc/model/local/content/content_local_impl.dart'
    as _i9;
import 'package:base_flutter_bloc/model/network/content/content_network.dart'
    as _i10;
import 'package:base_flutter_bloc/model/repository/content/content_repository.dart'
    as _i11;
import 'package:base_flutter_bloc/model/repository/content/content_repository_impl.dart'
    as _i12;
import 'package:dio/dio.dart' as _i5;
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
    final registerModule = _$RegisterModule();
    gh.factory<_i3.HomeBloc>(() => _i3.HomeBloc());
    gh.factory<_i4.LoginBloc>(() => _i4.LoginBloc());
    gh.singleton<_i5.Dio>(() => registerModule.prefs);
    gh.singleton<_i6.LogUtils>(() => _i6.LogUtils());
    gh.singleton<_i7.AppBloc>(() => _i7.AppBloc());
    gh.factory<_i8.ContentLocal>(() => _i9.ContentLocalImpl());
    gh.factory<_i10.ContentNetwork>(() => _i10.ContentNetwork(gh<_i5.Dio>()));
    gh.factory<_i11.ContentRepository>(
        () => _i12.ContentRepositoryImpl(gh<_i10.ContentNetwork>()));
    return this;
  }
}

class _$RegisterModule extends _i13.RegisterModule {}
