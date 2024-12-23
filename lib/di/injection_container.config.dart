// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:base_flutter_bloc/common/logger/logger.dart' as _i118;
import 'package:base_flutter_bloc/data/data_source/local/content/content_local.dart'
    as _i354;
import 'package:base_flutter_bloc/data/data_source/local/content/content_local_impl.dart'
    as _i47;
import 'package:base_flutter_bloc/data/data_source/remote/content/content_network.dart'
    as _i323;
import 'package:base_flutter_bloc/data/repositories/content/content_repository_impl.dart'
    as _i420;
import 'package:base_flutter_bloc/data/repositories/user/user_repository.dart'
    as _i471;
import 'package:base_flutter_bloc/di/modules.dart' as _i420;
import 'package:base_flutter_bloc/domain/repositories/content_repository.dart'
    as _i1066;
import 'package:base_flutter_bloc/domain/repositories/user_repository.dart'
    as _i315;
import 'package:base_flutter_bloc/domain/use_cases/login_usecase.dart' as _i445;
import 'package:base_flutter_bloc/presentation/bloc/app/app_bloc.dart' as _i775;
import 'package:base_flutter_bloc/presentation/bloc/home/home_bloc.dart'
    as _i652;
import 'package:base_flutter_bloc/presentation/bloc/login/login_bloc.dart'
    as _i647;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.factory<_i652.HomeBloc>(() => _i652.HomeBloc());
    gh.factory<_i647.LoginBloc>(() => _i647.LoginBloc());
    gh.singleton<_i361.Dio>(() => registerModule.prefs);
    gh.singleton<_i118.LogUtils>(() => _i118.LogUtils());
    gh.singleton<_i775.AppBloc>(() => _i775.AppBloc());
    gh.factory<_i315.UserRepository>(() => _i471.UserRepositoryImpl());
    gh.factory<_i323.ContentNetwork>(
        () => _i323.ContentNetwork(gh<_i361.Dio>()));
    gh.factory<_i445.LoginUseCase>(
        () => _i445.LoginUseCase(gh<_i315.UserRepository>()));
    gh.factory<_i354.ContentLocal>(() => _i47.ContentLocalImpl());
    gh.factory<_i1066.ContentRepository>(
        () => _i420.ContentRepositoryImpl(gh<_i323.ContentNetwork>()));
    return this;
  }
}

class _$RegisterModule extends _i420.RegisterModule {}
