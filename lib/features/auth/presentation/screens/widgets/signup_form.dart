import 'package:flutter/material.dart';
import 'package:jesoor_pro/config/theme/app_dimensions.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../core/widgets/custom_button.dart';
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
              text: "General",
              onTap: () => onSystemSelect("General"),
            ),
            const SizedBox(height: 10),
            SelectionCard(text: "Azhar", onTap: () => onSystemSelect("Azhar")),
            const SizedBox(height: 10),
            SelectionCard(
              text: "Languages",
              onTap: () => onSystemSelect("Languages"),
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
              text: "Primary",
              onTap: () => onStageSelect("Primary"),
            ),
            const SizedBox(height: 10),
            SelectionCard(
              text: "Preparatory",
              onTap: () => onStageSelect("Preparatory"),
            ),
            const SizedBox(height: 10),
            SelectionCard(
              text: "Secondary",
              onTap: () => onStageSelect("Secondary"),
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
                hintText: 'Enter Full Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppDimensions.fieldSpacing),
              CustomTextField(
                controller: emailController,
                hintText: 'Phone number',
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone number is required';
                  }
                  if (!RegExp(r'^01[0125][0-9]{8}$').hasMatch(value)) {
                    return 'Enter a valid Egyptian phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              CustomButton(
                text: 'SIGNUP',
                onPressed: onSignup,
              ),
            ] else if (step == 2) ...[
              CustomTextField(
                controller: parentPhoneController,
                hintText: 'Parent Phone',
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Parent Phone is required';
                  }
                  if (!RegExp(r'^01[0125][0-9]{8}$').hasMatch(value)) {
                    return 'Enter a valid Egyptian phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppDimensions.fieldSpacing),
              CustomTextField(
                controller: parentPhoneOptController,
                hintText: 'Parent Phone (Optional)',
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (!RegExp(r'^01[0125][0-9]{8}$').hasMatch(value)) {
                      return 'Enter a valid Egyptian phone number';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppDimensions.fieldSpacing),
              CustomTextField(
                controller: schoolController,
                hintText: 'School Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'School Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppDimensions.fieldSpacing),
              CustomTextField(
                controller: governorateController,
                hintText: 'Governorate',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Governorate is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              CustomButton(
                text: 'SAVE',
                onPressed: onSignup,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
