import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jesoor_pro/features/auth/login/presentation/cubit/login_cubit.dart';
import 'package:jesoor_pro/features/auth/login/presentation/cubit/login_state.dart';
import 'package:jesoor_pro/features/auth/login/presentation/utils/login_listener_handler.dart';
import 'package:jesoor_pro/features/auth/login/presentation/controllers/auth_form_controller.dart';
import 'package:jesoor_pro/features/auth/login/presentation/screens/widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  final AuthFormController formController;

  const LoginScreen({super.key, required this.formController});

  void _performLogin(BuildContext context) {
    if (formController.loginFormKey.currentState!.validate()) {
      final phone = formController.loginPhoneController.text;
      context.read<LoginCubit>().loginSendOtp(phone);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          LoginListenerHandler.handleStateChange(context, state);
        },
        child: LoginForm(
          formKey: formController.loginFormKey,
          phoneController: formController.loginPhoneController,
          onLogin: () => _performLogin(context),
        ),
      ),
    );
  }
}
