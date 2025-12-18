import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jesoor_pro/config/theme/app_colors.dart';
import 'package:jesoor_pro/core/utils/strings.dart';
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

    // Load governorates when opening signup tab
    _tabController.addListener(_onTabChanged);

    // Load governorates immediately if signup tab is initially selected
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _tabController.index == 1) {
        final cubit = context.read<AuthCubit>();
        if (cubit.state.governorates.isEmpty &&
            cubit.state.getGovernoratesStatus != AuthStatus.loading) {
          cubit.getGovernorates();
        }
      }
    });
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging && mounted) {
      // When switching to signup tab (index 1), load governorates
      if (_tabController.index == 1) {
        final cubit = context.read<AuthCubit>();
        if (cubit.state.governorates.isEmpty &&
            cubit.state.getGovernoratesStatus != AuthStatus.loading) {
          cubit.getGovernorates();
        }
      }
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _formController.dispose();
    super.dispose();
  }

  void _performLogin() {
    if (_formController.loginFormKey.currentState!.validate()) {
      final phone = _formController.loginPhoneController.text;
      context.read<AuthCubit>().loginSendOtp(phone);
    }
  }

  void _performSignup() {
    final cubit = context.read<AuthCubit>();
    cubit.signup(
      username: _formController.signupNameController.text,
      email: _formController.signupEmailController.text,
      password: _formController.signupPasswordController.text,
      parentPhone: _formController.signupPhoneController.text,
      schoolName: _formController.signupSchoolController.text,
      governorate: _formController.signupGovernorateController.text,
    );
  }

  void _handleSignupNextStep(AuthCubit cubit, int currentStep) {
    if (currentStep == 1) {
      if (_formController.signupFormKey.currentState!.validate()) {
        ConfirmPhoneDialog.show(
          context: context,
          email: _formController.signupPhoneController.text,
          onConfirm: () {
            cubit.sendOtp(
              _formController.signupNameController.text,
              _formController.signupPhoneController.text,
            );
          },
          onCancel: () {},
        );
      }
    } else if (currentStep == 2) {
      if (_formController.signupFormKey.currentState!.validate()) {
        // Check if governorate is selected
        if (_formController.signupGovernorateController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(Strings.governorateRequired),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        // Call API - it will move to step 3 on success
        cubit.completeStep2(
          email: _formController.signupEmailController.text,
          guardianPhone: _formController.signupParentPhoneController.text,
          secondGuardianPhone:
              _formController.signupParentPhoneOptController.text.isEmpty
              ? null
              : _formController.signupParentPhoneOptController.text,
          schoolName: _formController.signupSchoolController.text,
          governorate: _formController.signupGovernorateController.text,
        );
      }
    } else if (currentStep == 3) {
      // Step 3: Categories loading is handled by listener handler
      // No need to manually trigger here to avoid duplicate calls
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
                                  phoneController:
                                      _formController.loginPhoneController,
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
                                        phoneController: _formController
                                            .signupPhoneController,
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
                                        },
                                        onCategorySelect: (category) {
                                          cubit.selectCategory(category);
                                        },
                                        onChildCategorySelect: (category) {
                                          cubit.completeStep3(category.id);
                                        },
                                        onBack:
                                            state.signupStep > 1 &&
                                                state.signupStep <= 5
                                            ? () => cubit.previousSignupStep()
                                            : null,
                                        availableGrades: state.availableGrades,
                                        availableGovernorates:
                                            state.governorates,
                                        availableCategories: state.categories,
                                        availableCategoryChildren:
                                            state.selectedCategoryChildren,
                                        selectedGrade: state.educationGrade,
                                        selectedCategory:
                                            state.selectedCategory,
                                        selectedChildCategory:
                                            null, // Will be handled by temp selection
                                        getCategoriesStatus:
                                            state.getCategoriesStatus,
                                        getCategoryChildrenStatus:
                                            state.getCategoryChildrenStatus,
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
