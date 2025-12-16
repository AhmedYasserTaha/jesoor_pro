import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jesoor_pro/config/theme/app_colors.dart';
import 'package:jesoor_pro/core/widgets/custom_text.dart';
import 'package:jesoor_pro/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:jesoor_pro/features/auth/presentation/cubit/auth_state.dart';

import 'widgets/auth_header.dart';
import 'widgets/auth_tab_bar.dart';
import 'widgets/login_form.dart';
import 'widgets/signup_form.dart';
import 'widgets/step_indicator.dart';
import 'widgets/otp_verification_dialog.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _loginFormKey = GlobalKey<FormState>();
  final _signupFormKey = GlobalKey<FormState>();

  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();

  final _signupNameController = TextEditingController();
  final _signupEmailController = TextEditingController();
  final _signupPasswordController = TextEditingController();

  // Step 2 Controllers
  final _signupParentPhoneController = TextEditingController();
  final _signupParentPhoneOptController = TextEditingController();
  final _signupSchoolController = TextEditingController();
  final _signupGovernorateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _signupNameController.dispose();
    _signupEmailController.dispose();
    _signupPasswordController.dispose();
    _signupParentPhoneController.dispose();
    _signupParentPhoneOptController.dispose();
    _signupSchoolController.dispose();
    _signupGovernorateController.dispose();
    super.dispose();
  }

  void _performLogin() {
    if (_loginFormKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
        _loginEmailController.text,
        _loginPasswordController.text,
      );
    }
  }

  void _performSignup() {
    // Collect all data and call cubit.signup
    // Note: Some data is in controllers, some in Cubit state (system, stage, grade)
    final cubit = context.read<AuthCubit>();
    cubit.signup(
      username: _signupNameController.text,
      email: _signupEmailController.text,
      password: _signupPasswordController.text,
      parentPhone: _signupParentPhoneController.text,
      schoolName: _signupSchoolController.text,
      governorate: _signupGovernorateController.text,
    );
  }

  void _handleSignupNextStep(AuthCubit cubit, int currentStep) {
    if (currentStep == 1) {
      if (_signupFormKey.currentState!.validate()) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirm Phone Number'),
            content: Text(
              'We will send an OTP code to ${_signupEmailController.text}.\nIs this correct?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  cubit.sendOtp(
                    _signupNameController.text,
                    _signupEmailController.text,
                  );
                },
                child: const Text('Confirm'),
              ),
            ],
          ),
        );
      }
    } else if (currentStep == 2) {
      if (_signupFormKey.currentState!.validate()) {
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
            if (state.status == AuthStatus.success) {
              // TODO: Navigate to Home/Root screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Auth Success! Navigating to Home...'),
                ),
              );
            } else if (state.status == AuthStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage ?? 'Unknown Error')),
              );
            } else if (state.status == AuthStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage ?? 'Unknown Error')),
              );
            } else if (state.sendOtpStatus == AuthStatus.loading) {
              // Show Loading Dialog
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              );
            } else if (state.sendOtpStatus == AuthStatus.success) {
              // Dismiss Loading Dialog if it is open (it should be)
              // We blindly pop assuming the loading dialog is top-most.
              // To be safer, we can check but simplified flow usually works if states are sequential.
              Navigator.pop(context);

              // Show OTP Dialog
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => OtpVerificationDialog(
                  phone: state.phone ?? '',
                  onVerify: (otp) {
                    // Do NOT pop here. Let the dialog handle loading state.
                    // Just call verify.
                    context.read<AuthCubit>().verifyOtp(
                      otp,
                      "test-device-token",
                      "test-device-label",
                    );
                  },
                ),
              );
            } else if (state.sendOtpStatus == AuthStatus.error) {
              Navigator.pop(context); // Dismiss Loading Dialog
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.errorMessage ?? 'Error sending OTP',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state.verifyOtpStatus == AuthStatus.success) {
              Navigator.pop(context); // Dismiss OTP Dialog

              // Show Success Dialog then move to step 2
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/cograt.png',
                        height: 150,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 20),
                      CustomText(
                        "I created a new account — congratulations 🎉",
                        textAlign: TextAlign.center,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 10),
                      CustomText(
                        "There are just a few simple steps left so you can start using your account.",
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                  actions: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          Navigator.pop(context); // Close success dialog
                          context.read<AuthCubit>().setSignupStep(2);
                        },
                        child: const Text(
                          'Next',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state.verifyOtpStatus == AuthStatus.error) {
              // Don't dismiss OTP dialog on error, just show toast
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.errorMessage ?? 'Invalid OTP',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
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
                                  formKey: _loginFormKey,
                                  emailController: _loginEmailController,
                                  passwordController: _loginPasswordController,
                                  obscurePassword: state
                                      .isPasswordVisible, // Reusing isPasswordVisible for both? Or separate?
                                  // Note: UI usually shares state or has separate toggle.
                                  // Assuming shared for simplicity or specific logic.
                                  // Actually state has isPasswordVisible.
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
                                        formKey: _signupFormKey,
                                        nameController: _signupNameController,
                                        emailController: _signupEmailController,
                                        passwordController:
                                            _signupPasswordController,
                                        obscurePassword:
                                            state.isPasswordVisible,
                                        onTogglePassword:
                                            cubit.togglePasswordVisibility,
                                        onSignup: () => _handleSignupNextStep(
                                          cubit,
                                          state.signupStep,
                                        ),
                                        step: state.signupStep,
                                        parentPhoneController:
                                            _signupParentPhoneController,
                                        parentPhoneOptController:
                                            _signupParentPhoneOptController,
                                        schoolController:
                                            _signupSchoolController,
                                        governorateController:
                                            _signupGovernorateController,
                                        onSystemSelect: cubit.selectSystem,
                                        onStageSelect: cubit.selectStage,
                                        onGradeSelect: (grade) {
                                          cubit.selectGrade(grade);
                                          // After selecting grade, perform signup
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
