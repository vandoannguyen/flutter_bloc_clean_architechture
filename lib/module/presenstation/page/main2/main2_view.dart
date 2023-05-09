import 'package:baese_flutter_bloc/di/injection_container.dart';
import 'package:baese_flutter_bloc/module/presenstation/bloc/app/app_bloc.dart';
import 'package:baese_flutter_bloc/module/presenstation/bloc/main2/main2_bloc.dart';
import 'package:base_bloc_module/views/base_view_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Main2View extends BaseViewCubit<Main2Bloc> {
  @override
  Widget buildWidget(BuildContext context) {
    return BlocProvider<AppBloc>(
      create: (ctx) => getIt<AppBloc>(),
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: bloc?.loginGoogle,
                excludeFromSemantics: true,
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("Google"),
                ),
              ),
              GestureDetector(
                onTap: bloc?.loginFacebook,
                excludeFromSemantics: true,
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("Facebook"),
                ),
              ),
              GestureDetector(
                onTap: bloc?.loginApple,
                excludeFromSemantics: true,
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("Apple"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initEventViewModel(Object? state) {

  }

  @override
  Main2Bloc initBloc() {
    return getIt<Main2Bloc>();
  }
}
