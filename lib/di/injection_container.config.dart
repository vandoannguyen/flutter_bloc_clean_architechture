// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:base_flutter_bloc/bloc/app/app_bloc.dart' as _i71;
import 'package:base_flutter_bloc/bloc/home/home_bloc.dart' as _i722;
import 'package:base_flutter_bloc/bloc/login/login_bloc.dart' as _i41;
import 'package:base_flutter_bloc/common/logger/logger.dart' as _i118;
import 'package:base_flutter_bloc/di/modules.dart' as _i420;
import 'package:base_flutter_bloc/model/local/content/content_local.dart'
    as _i624;
import 'package:base_flutter_bloc/model/local/content/content_local_impl.dart'
    as _i610;
import 'package:base_flutter_bloc/model/network/content/content_network.dart'
    as _i622;
import 'package:base_flutter_bloc/model/repository/content/content_repository.dart'
    as _i793;
import 'package:base_flutter_bloc/model/repository/content/content_repository_impl.dart'
    as _i956;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.factory<_i722.HomeBloc>(() => _i722.HomeBloc());
    gh.factory<_i41.LoginBloc>(() => _i41.LoginBloc());
    gh.singleton<_i71.AppBloc>(() => _i71.AppBloc());
    gh.singleton<_i118.LogUtils>(() => _i118.LogUtils());
    gh.singleton<_i361.Dio>(() => registerModule.prefs);
    gh.factory<_i624.ContentLocal>(() => _i610.ContentLocalImpl());
    gh.factory<_i622.ContentNetwork>(
      () => _i622.ContentNetwork(gh<_i361.Dio>()),
    );
    gh.factory<_i793.ContentRepository>(
      () => _i956.ContentRepositoryImpl(gh<_i622.ContentNetwork>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i420.RegisterModule {}
