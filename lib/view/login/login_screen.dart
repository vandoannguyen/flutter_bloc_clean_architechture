import 'package:base_bloc_module/index.dart';
import 'package:base_flutter_bloc/bloc/login/login_bloc.dart';
import 'package:base_flutter_bloc/bloc/login/login_state.dart';
import 'package:base_flutter_bloc/di/injection_container.dart';
import 'package:base_flutter_bloc/routes/index.dart';
import 'package:base_flutter_bloc/utils/index.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState
    extends BaseViewCubitState<LoginBloc, LoginState, LoginEvent, LoginScreen> {
  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: bloc?.handleLogin,
          child: const Text("To Home"),
        ),
      ),
    );
  }

  @override
  LoginBloc initBloc() {
    return getIt<LoginBloc>();
  }

  @override
  void initData() {}

  @override
  void initEventViewModel(BuildContext context, LoginEvent state) {
    state.when(moveToHome: () {
      NavigatorUtils.instance.pushReplacementNamed(AppRoutes.home.routeName);
    });
  }
}
