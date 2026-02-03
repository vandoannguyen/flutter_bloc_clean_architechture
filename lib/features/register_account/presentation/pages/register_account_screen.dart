import 'package:base_bloc_module/index.dart';
import 'package:flutter/material.dart';
import '../../../../core/di/injection_container.dart';
import '../bloc/register_account_bloc.dart';
import '../bloc/register_account_state.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Account'),
      ),
      body: BlocBuilderDataState<RegisterAccountBloc, RegisterAccountState>(
        bloc: bloc,
        builder: (context, state) {
          return const Center(
            child: Text('Register Account Screen'),
          );
        },
      ),
    );
  }

  @override
  RegisterAccountBloc initBloc() {
    return getIt<RegisterAccountBloc>();
  }

  @override
  void initData() {}

  @override
  void initEventViewModel(BuildContext context, RegisterAccountEvent state) {
    state.when(
      navigateToLogin: () {
        // Handle navigation to login
      },
    );
  }
}
