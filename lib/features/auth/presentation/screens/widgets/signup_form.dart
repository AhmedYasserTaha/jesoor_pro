import 'package:flutter/material.dart';
import 'package:jesoor_pro/config/theme/app_dimensions.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/utils/strings.dart';
import 'package:jesoor_pro/features/auth/presentation/screens/widgets/selection_card.dart';

class SignupForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onSignup;

  // New fields for Step 2
  final int step;
  final TextEditingController parentPhoneController;
  final TextEditingController parentPhoneOptController;
  final TextEditingController schoolController;
  final TextEditingController governorateController;

  // Callbacks for Steps 3, 4, 5
  final Function(String) onSystemSelect;
  final Function(String) onStageSelect;
  final Function(String) onGradeSelect;

  // Data for selections
  final List<String> availableGrades; // passed from parent based on stage

  const SignupForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePassword,
    required this.onSignup,
    required this.step,
    required this.parentPhoneController,
    required this.parentPhoneOptController,
    required this.schoolController,
    required this.governorateController,
    required this.onSystemSelect,
    required this.onStageSelect,
    required this.onGradeSelect,
    this.availableGrades = const [],
  });

  @override
  Widget build(BuildContext context) {
    if (step == 3) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.formPadding),
        child: Column(
          children: [
            SelectionCard(
              text: Strings.general,
              onTap: () => onSystemSelect(Strings.general),
            ),
            const SizedBox(height: 10),
            SelectionCard(
              text: Strings.azhar,
              onTap: () => onSystemSelect(Strings.azhar),
            ),
            const SizedBox(height: 10),
            SelectionCard(
              text: Strings.languages,
              onTap: () => onSystemSelect(Strings.languages),
            ),
          ],
        ),
      );
    }

    if (step == 4) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.formPadding),
        child: Column(
          children: [
            SelectionCard(
              text: Strings.primary,
              onTap: () => onStageSelect(Strings.primary),
            ),
            const SizedBox(height: 10),
            SelectionCard(
              text: Strings.preparatory,
              onTap: () => onStageSelect(Strings.preparatory),
            ),
            const SizedBox(height: 10),
            SelectionCard(
              text: Strings.secondary,
              onTap: () => onStageSelect(Strings.secondary),
            ),
          ],
        ),
      );
    }

    if (step == 5) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.fieldSpacing),
        child: Column(
          children: [
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: availableGrades.length,
              separatorBuilder: (c, i) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                return SelectionCard(
                  text: availableGrades[index],
                  onTap: () => onGradeSelect(availableGrades[index]),
                );
              },
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.formPadding),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppDimensions.fieldSpacing),
            if (step == 1) ...[
              CustomTextField(
                controller: nameController,
                hintText: Strings.enterFullName,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return Strings.nameRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppDimensions.fieldSpacing),
              CustomTextField(
                controller: emailController,
                hintText: Strings.phoneNumber,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return Strings.phoneNumberRequired;
                  }
                  if (!RegExp(r'^01[0125][0-9]{8}$').hasMatch(value)) {
                    return Strings.enterValidEgyptianPhone;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              CustomButton(text: Strings.signup, onPressed: onSignup),
            ] else if (step == 2) ...[
              CustomTextField(
                controller: parentPhoneController,
                hintText: Strings.parentPhone,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return Strings.parentPhoneRequired;
                  }
                  if (!RegExp(r'^01[0125][0-9]{8}$').hasMatch(value)) {
                    return Strings.enterValidEgyptianPhone;
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppDimensions.fieldSpacing),
              CustomTextField(
                controller: parentPhoneOptController,
                hintText: Strings.parentPhoneOptional,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (!RegExp(r'^01[0125][0-9]{8}$').hasMatch(value)) {
                      return Strings.enterValidEgyptianPhone;
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppDimensions.fieldSpacing),
              CustomTextField(
                controller: schoolController,
                hintText: Strings.schoolName,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return Strings.schoolNameRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppDimensions.fieldSpacing),
              CustomTextField(
                controller: governorateController,
                hintText: Strings.governorate,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return Strings.governorateRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              CustomButton(text: Strings.save, onPressed: onSignup),
            ],
          ],
        ),
      ),
    );
  }
}
