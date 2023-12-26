// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:base_flutter_bloc/bloc/app/app_bloc.dart' as _i3;
import 'package:base_flutter_bloc/bloc/main/main_view_bloc.dart' as _i12;
import 'package:base_flutter_bloc/bloc/main2/main2_bloc.dart' as _i11;
import 'package:base_flutter_bloc/common/logger/logger.dart' as _i7;
import 'package:base_flutter_bloc/di/modules.dart' as _i13;
import 'package:base_flutter_bloc/model/local/content/content_local.dart'
    as _i4;
import 'package:base_flutter_bloc/model/local/content/content_local_impl.dart'
    as _i5;
import 'package:base_flutter_bloc/model/network/content/content_network.dart'
    as _i8;
import 'package:base_flutter_bloc/model/repository/content/content_repository.dart'
    as _i9;
import 'package:base_flutter_bloc/model/repository/content/content_repository_impl.dart'
    as _i10;
import 'package:dio/dio.dart' as _i6;
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
    gh.singleton<_i3.AppBloc>(_i3.AppBloc());
    gh.factory<_i4.ContentLocal>(() => _i5.ContentLocalImpl());
    gh.singleton<_i6.Dio>(registerModule.prefs);
    gh.singleton<_i7.LogUtils>(_i7.LogUtils());
    gh.factory<_i8.ContentNetwork>(() => _i8.ContentNetwork(gh<_i6.Dio>()));
    gh.factory<_i9.ContentRepository>(() => _i10.ContentRepositoryImpl(
          gh<_i4.ContentLocal>(),
          gh<_i8.ContentNetwork>(),
        ));
    gh.factory<_i11.Main2Bloc>(
        () => _i11.Main2Bloc(gh<_i9.ContentRepository>()));
    gh.factory<_i12.MainBloc>(() => _i12.MainBloc(gh<_i9.ContentRepository>()));
    return this;
  }
}

class _$RegisterModule extends _i13.RegisterModule {}
