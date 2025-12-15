import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jesoor_pro/config/locators/app_locator.dart';
import 'package:jesoor_pro/core/widgets/app_button.dart';
import 'package:jesoor_pro/core/widgets/app_text_field.dart';
import 'package:jesoor_pro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:jesoor_pro/features/auth/presentation/bloc/auth_event.dart';
import 'package:jesoor_pro/features/auth/presentation/bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthBloc>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              } else if (state is AuthSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Welcome ${state.user.username}"),
                    backgroundColor: Colors.green,
                  ),
                );
                // Navigate to logic
              }
            },
            builder: (context, state) {
              if (state is AuthLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppTextField(hint: 'Email', controller: _emailController),
                  const SizedBox(height: 20),
                  AppTextField(
                    hint: 'Password',
                    controller: _passwordController,
                  ),
                  const SizedBox(height: 40),
                  AppButton(
                    text: 'Login',
                    onPressed: () {
                      context.read<AuthBloc>().add(
                        LoginEvent(
                          email: _emailController.text,
                          password: _passwordController.text,
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
