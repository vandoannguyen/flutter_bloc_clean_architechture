import 'package:base_bloc_module/index.dart';
import 'package:flutter/material.dart';
import '../bloc/index.dart';
import '../../../../shared/utils/navigate_utils.dart';
import '../../../../shared/routes/routes.dart';

/// Login screen.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState
    extends BaseViewCubitState<AuthBloc, AuthState, AuthEvent, LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                bloc?.login(
                  _emailController.text,
                  _passwordController.text,
                );
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  AuthBloc initBloc() {
    return getIt<AuthBloc>();
  }

  @override
  void initData() {}

  @override
  void initEventViewModel(BuildContext context, AuthEvent state) {
    state.when(
      navigateToHome: () {
        NavigatorUtils.instance.pushReplacementNamed(AppRoutes.home.routeName);
      },
      navigateToLogin: () {
        // Already on login screen
      },
      showError: (message) {
        // Error handled by showMessage in BLoC
      },
    );
  }
}
