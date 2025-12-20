import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jesoor_pro/config/theme/app_colors.dart';
import 'package:jesoor_pro/core/utils/strings.dart';
import 'package:jesoor_pro/features/auth/signup/presentation/cubit/signup_cubit.dart';
import 'package:jesoor_pro/features/auth/signup/presentation/cubit/signup_state.dart';
import 'package:jesoor_pro/features/auth/signup/presentation/utils/signup_listener_handler.dart';
import 'package:jesoor_pro/features/auth/login/presentation/controllers/auth_form_controller.dart';
import 'package:jesoor_pro/features/auth/signup/presentation/screens/widgets/confirm_phone_dialog.dart';
import 'package:jesoor_pro/features/auth/signup/presentation/screens/widgets/signup_form.dart';
import 'package:jesoor_pro/features/auth/signup/presentation/screens/widgets/step_indicator.dart';

class SignupScreen extends StatefulWidget {
  final AuthFormController formController;

  const SignupScreen({super.key, required this.formController});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  void initState() {
    super.initState();
    // Load governorates when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final cubit = context.read<SignupCubit>();
        if (cubit.state.governorates.isEmpty &&
            cubit.state.getGovernoratesStatus != SignupStatus.loading) {
          cubit.getGovernorates();
        }
      }
    });
  }

  void _performSignup(BuildContext context) {
    final cubit = context.read<SignupCubit>();
    cubit.signup(
      username: widget.formController.signupNameController.text,
      email: widget.formController.signupEmailController.text,
      password: widget.formController.signupPasswordController.text,
      parentPhone: widget.formController.signupPhoneController.text,
      schoolName: widget.formController.signupSchoolController.text,
      governorate: widget.formController.signupGovernorateController.text,
    );
  }

  void _handleSignupNextStep(BuildContext context, int currentStep) {
    final cubit = context.read<SignupCubit>();
    if (currentStep == 1) {
      if (widget.formController.signupFormKey.currentState!.validate()) {
        ConfirmPhoneDialog.show(
          context: context,
          email: widget.formController.signupPhoneController.text,
          onConfirm: () {
            cubit.sendOtp(
              widget.formController.signupNameController.text,
              widget.formController.signupPhoneController.text,
            );
          },
          onCancel: () {},
        );
      }
    } else if (currentStep == 2) {
      if (widget.formController.signupFormKey.currentState!.validate()) {
        // Check if governorate is selected
        if (widget.formController.signupGovernorateController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(Strings.governorateRequired),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        // Call API - it will move to step 3 on success
        cubit.completeStep2(
          email: widget.formController.signupEmailController.text,
          guardianPhone: widget.formController.signupParentPhoneController.text,
          secondGuardianPhone:
              widget.formController.signupParentPhoneOptController.text.isEmpty
              ? null
              : widget.formController.signupParentPhoneOptController.text,
          schoolName: widget.formController.signupSchoolController.text,
          governorate: widget.formController.signupGovernorateController.text,
        );
      }
    } else if (currentStep == 3) {
      // Step 3: Categories loading is handled by listener handler
      // No need to manually trigger here to avoid duplicate calls
    } else if (currentStep == 5) {
      _performSignup(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocListener<SignupCubit, SignupState>(
        listener: (context, state) {
          SignupListenerHandler.handleStateChange(context, state);
        },
        child: BlocBuilder<SignupCubit, SignupState>(
          builder: (context, signupState) {
            final signupCubit = context.read<SignupCubit>();
            return Column(
              children: [
                StepIndicator(
                  currentStep: signupState.signupStep >= 3
                      ? 3
                      : signupState.signupStep,
                ),
                Expanded(
                  child: SignupForm(
                    formKey: widget.formController.signupFormKey,
                    nameController: widget.formController.signupNameController,
                    phoneController:
                        widget.formController.signupPhoneController,
                    emailController:
                        widget.formController.signupEmailController,
                    passwordController:
                        widget.formController.signupPasswordController,
                    obscurePassword: signupState.isPasswordVisible,
                    onTogglePassword: signupCubit.togglePasswordVisibility,
                    onSignup: () =>
                        _handleSignupNextStep(context, signupState.signupStep),
                    step: signupState.signupStep,
                    parentPhoneController:
                        widget.formController.signupParentPhoneController,
                    parentPhoneOptController:
                        widget.formController.signupParentPhoneOptController,
                    schoolController:
                        widget.formController.signupSchoolController,
                    governorateController:
                        widget.formController.signupGovernorateController,
                    onSystemSelect: signupCubit.selectSystem,
                    onStageSelect: signupCubit.selectStage,
                    onGradeSelect: (grade) {
                      signupCubit.selectGrade(grade);
                    },
                    onCategorySelect: (category) {
                      signupCubit.selectCategory(category);
                    },
                    onChildCategorySelect: (category) {
                      signupCubit.completeStep3(category.id);
                    },
                    onBack:
                        signupState.signupStep > 3 &&
                            signupState.signupStep <= 5
                        ? () => signupCubit.previousSignupStep()
                        : null,
                    availableGrades: signupState.availableGrades,
                    availableGovernorates: signupState.governorates,
                    availableCategories: signupState.categories,
                    availableCategoryChildren:
                        signupState.selectedCategoryChildren,
                    selectedGrade: signupState.educationGrade,
                    selectedCategory: signupState.selectedCategory,
                    selectedChildCategory:
                        null, // Will be handled by temp selection
                    getCategoriesStatus: signupState.getCategoriesStatus,
                    getCategoryChildrenStatus:
                        signupState.getCategoryChildrenStatus,
                    completeStep2Status: signupState.completeStep2Status,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
