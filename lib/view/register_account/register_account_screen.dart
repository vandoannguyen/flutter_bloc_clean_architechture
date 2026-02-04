import 'package:base_bloc_module/index.dart';

import 'package:base_flutter_bloc/bloc/register_account/register_account_cubit.dart';
import 'package:base_flutter_bloc/bloc/register_account/register_account_state.dart';
import 'package:base_flutter_bloc/core/di/injection_container.dart';
import 'package:flutter/material.dart';

class RegisterAccountScreen extends StatefulWidget {
  const RegisterAccountScreen({super.key});

  @override
  State<RegisterAccountScreen> createState() => _RegisterAccountScreenState();
}

class _RegisterAccountScreenState extends BaseViewCubitState<
    RegisterAccountBloc,
    RegisterAccountState,
    RegisterAccountEvent,
    RegisterAccountScreen> {
  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold();
  }

  @override
  RegisterAccountBloc initBloc() {
    return getIt<RegisterAccountBloc>();
  }

  @override
  void initData() {}

  @override
  void initEventViewModel(BuildContext context, RegisterAccountEvent state) {}
}

