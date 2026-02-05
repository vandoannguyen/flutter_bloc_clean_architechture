// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:base_flutter_bloc/bloc/app/app_bloc.dart' as _i1036;
import 'package:base_flutter_bloc/bloc/home/home_bloc.dart' as _i1046;
import 'package:base_flutter_bloc/bloc/login/login_bloc.dart' as _i537;
import 'package:base_flutter_bloc/common/logger/logger.dart' as _i973;
import 'package:base_flutter_bloc/di/modules.dart' as _i35;
import 'package:base_flutter_bloc/model/local/content/content_local.dart' as _i21;
import 'package:base_flutter_bloc/model/local/content/content_local_impl.dart' as _i233;
import 'package:base_flutter_bloc/model/network/content/content_network.dart' as _i295;
import 'package:base_flutter_bloc/model/repository/content/content_repository.dart' as _i64;
import 'package:base_flutter_bloc/model/repository/content/content_repository_impl.dart'
    as _i919;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.factory<_i1046.HomeBloc>(() => _i1046.HomeBloc());
    gh.factory<_i537.LoginBloc>(() => _i537.LoginBloc());
    gh.singleton<_i1036.AppBloc>(() => _i1036.AppBloc());
    gh.singleton<_i973.LogUtils>(() => _i973.LogUtils());
    gh.singleton<_i361.Dio>(() => registerModule.prefs);
    gh.factory<_i21.ContentLocal>(() => _i233.ContentLocalImpl());
    gh.factory<_i295.ContentNetwork>(
      () => _i295.ContentNetwork(gh<_i361.Dio>()),
    );
    gh.factory<_i64.ContentRepository>(
      () => _i919.ContentRepositoryImpl(gh<_i295.ContentNetwork>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i35.RegisterModule {}
