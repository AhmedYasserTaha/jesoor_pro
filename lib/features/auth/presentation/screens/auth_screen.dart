import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jesoor_pro/config/theme/app_colors.dart';
import 'package:jesoor_pro/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:jesoor_pro/features/auth/presentation/cubit/auth_state.dart';
import 'package:jesoor_pro/features/auth/presentation/controllers/auth_form_controller.dart';
import 'package:jesoor_pro/features/auth/presentation/utils/auth_listener_handler.dart';
import 'package:jesoor_pro/features/auth/presentation/screens/widgets/confirm_phone_dialog.dart';

import 'widgets/auth_header.dart';
import 'widgets/auth_tab_bar.dart';
import 'widgets/login_form.dart';
import 'widgets/signup_form.dart';
import 'widgets/step_indicator.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late AuthFormController _formController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _formController = AuthFormController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _formController.dispose();
    super.dispose();
  }

  void _performLogin() {
    if (_formController.loginFormKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
        _formController.loginEmailController.text,
        _formController.loginPasswordController.text,
      );
    }
  }

  void _performSignup() {
    final cubit = context.read<AuthCubit>();
    cubit.signup(
      username: _formController.signupNameController.text,
      email: _formController.signupEmailController.text,
      password: _formController.signupPasswordController.text,
      parentPhone: _formController.signupParentPhoneController.text,
      schoolName: _formController.signupSchoolController.text,
      governorate: _formController.signupGovernorateController.text,
    );
  }

  void _handleSignupNextStep(AuthCubit cubit, int currentStep) {
    if (currentStep == 1) {
      if (_formController.signupFormKey.currentState!.validate()) {
        ConfirmPhoneDialog.show(
          context: context,
          email: _formController.signupEmailController.text,
          onConfirm: () {
            cubit.sendOtp(
              _formController.signupNameController.text,
              _formController.signupEmailController.text,
            );
          },
          onCancel: () {},
        );
      }
    } else if (currentStep == 2) {
      if (_formController.signupFormKey.currentState!.validate()) {
        cubit.setSignupStep(3);
      }
    } else if (currentStep == 5) {
      _performSignup();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            AuthListenerHandler.handleStateChange(context, state);
          },
          builder: (context, state) {
            final cubit = context.read<AuthCubit>();
            return SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  const AuthHeader(),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          AuthTabBar(tabController: _tabController),
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                LoginForm(
                                  formKey: _formController.loginFormKey,
                                  emailController:
                                      _formController.loginEmailController,
                                  passwordController:
                                      _formController.loginPasswordController,
                                  obscurePassword: state.isPasswordVisible,
                                  onTogglePassword:
                                      cubit.togglePasswordVisibility,
                                  onLogin: _performLogin,
                                ),
                                Column(
                                  children: [
                                    StepIndicator(
                                      currentStep: state.signupStep >= 3
                                          ? 3
                                          : state.signupStep,
                                    ),
                                    Expanded(
                                      child: SignupForm(
                                        formKey: _formController.signupFormKey,
                                        nameController: _formController
                                            .signupNameController,
                                        emailController: _formController
                                            .signupEmailController,
                                        passwordController: _formController
                                            .signupPasswordController,
                                        obscurePassword:
                                            state.isPasswordVisible,
                                        onTogglePassword:
                                            cubit.togglePasswordVisibility,
                                        onSignup: () => _handleSignupNextStep(
                                          cubit,
                                          state.signupStep,
                                        ),
                                        step: state.signupStep,
                                        parentPhoneController: _formController
                                            .signupParentPhoneController,
                                        parentPhoneOptController:
                                            _formController
                                                .signupParentPhoneOptController,
                                        schoolController: _formController
                                            .signupSchoolController,
                                        governorateController: _formController
                                            .signupGovernorateController,
                                        onSystemSelect: cubit.selectSystem,
                                        onStageSelect: cubit.selectStage,
                                        onGradeSelect: (grade) {
                                          cubit.selectGrade(grade);
                                          _performSignup();
                                        },
                                        availableGrades: state.availableGrades,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
