// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:baese_flutter_bloc/bloc/app/app_bloc.dart' as _i3;
import 'package:baese_flutter_bloc/bloc/main/main_view_bloc.dart' as _i11;
import 'package:baese_flutter_bloc/bloc/main2/main2_bloc.dart' as _i10;
import 'package:baese_flutter_bloc/model/local/content/content_local.dart'
    as _i4;
import 'package:baese_flutter_bloc/model/local/content/content_local_impl.dart'
    as _i5;
import 'package:baese_flutter_bloc/model/network/content/content_network.dart'
    as _i6;
import 'package:baese_flutter_bloc/model/network/content/content_network_impl.dart'
    as _i7;
import 'package:baese_flutter_bloc/model/repository/content/content_repository.dart'
    as _i8;
import 'package:baese_flutter_bloc/model/repository/content/content_repository_impl.dart'
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
    gh.factory<_i4.ContentLocal>(() => _i5.ContentLocalImpl());
    gh.factory<_i6.ContentNetwork>(() => _i7.ContentNetworkImpl());
    gh.factory<_i8.ContentRepository>(() => _i9.ContentRepositoryImpl(
          gh<_i4.ContentLocal>(),
          gh<_i6.ContentNetwork>(),
        ));
    gh.factory<_i10.Main2Bloc>(
        () => _i10.Main2Bloc(gh<_i8.ContentRepository>()));
    gh.factory<_i11.MainBloc>(() => _i11.MainBloc(gh<_i8.ContentRepository>()));
    return this;
  }
}
