import 'package:flutter/material.dart';
import 'package:jesoor_pro/config/theme/app_dimensions.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/utils/strings.dart';
import 'package:jesoor_pro/features/auth/presentation/screens/widgets/selection_card.dart';
import 'package:jesoor_pro/features/auth/domain/entities/governorate_entity.dart';
import 'package:jesoor_pro/features/auth/domain/entities/category_entity.dart';

class SignupForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController phoneController; // Phone for step 1
  final TextEditingController emailController; // Email for step 1
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
  final Function(CategoryEntity) onCategorySelect; // For selecting category

  // Data for selections
  final List<String> availableGrades; // passed from parent based on stage
  final List<GovernorateEntity> availableGovernorates; // passed from parent
  final List<CategoryEntity> availableCategories; // passed from parent

  const SignupForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.phoneController,
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
    required this.onCategorySelect,
    this.availableGrades = const [],
    this.availableGovernorates = const [],
    this.availableCategories = const [],
  });

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  String? _selectedGovernorate;

  @override
  void initState() {
    super.initState();
    _selectedGovernorate = widget.governorateController.text.isEmpty
        ? null
        : widget.governorateController.text;
    widget.governorateController.addListener(_onGovernorateChanged);
  }

  @override
  void dispose() {
    widget.governorateController.removeListener(_onGovernorateChanged);
    super.dispose();
  }

  void _onGovernorateChanged() {
    setState(() {
      _selectedGovernorate = widget.governorateController.text.isEmpty
          ? null
          : widget.governorateController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.step == 3) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.formPadding),
        child: Column(
          children: [
            if (widget.availableCategories.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else
              ...widget.availableCategories.map((category) {
                return Column(
                  children: [
                    SelectionCard(
                      text: category.name,
                      onTap: () => widget.onCategorySelect(category),
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              }).toList(),
          ],
        ),
      );
    }

    if (widget.step == 4) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.formPadding),
        child: Column(
          children: [
            SelectionCard(
              text: Strings.primary,
              onTap: () => widget.onStageSelect(Strings.primary),
            ),
            const SizedBox(height: 10),
            SelectionCard(
              text: Strings.preparatory,
              onTap: () => widget.onStageSelect(Strings.preparatory),
            ),
            const SizedBox(height: 10),
            SelectionCard(
              text: Strings.secondary,
              onTap: () => widget.onStageSelect(Strings.secondary),
            ),
          ],
        ),
      );
    }

    if (widget.step == 5) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.fieldSpacing),
        child: Column(
          children: [
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.availableGrades.length,
              separatorBuilder: (c, i) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                return SelectionCard(
                  text: widget.availableGrades[index],
                  onTap: () =>
                      widget.onGradeSelect(widget.availableGrades[index]),
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
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppDimensions.fieldSpacing),
            if (widget.step == 1) ...[
              CustomTextField(
                controller: widget.nameController,
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
                controller: widget.phoneController,
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
              const SizedBox(height: AppDimensions.fieldSpacing),
              CustomTextField(
                controller: widget.emailController,
                hintText: 'البريد الإلكتروني', // Email
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'البريد الإلكتروني مطلوب'; // Email is required
                  }
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value)) {
                    return 'يرجى إدخال بريد إلكتروني صحيح'; // Please enter a valid email
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              CustomButton(text: Strings.signup, onPressed: widget.onSignup),
            ] else if (widget.step == 2) ...[
              CustomTextField(
                controller: widget.parentPhoneController,
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
                controller: widget.parentPhoneOptController,
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
                controller: widget.schoolController,
                hintText: Strings.schoolName,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return Strings.schoolNameRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppDimensions.fieldSpacing),
              DropdownButtonFormField<String>(
                value: _selectedGovernorate,
                decoration: InputDecoration(
                  hintText: Strings.governorate,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                isExpanded: true,
                items: widget.availableGovernorates.map((governorate) {
                  // Use Arabic name first, fallback to English if Arabic is empty
                  final displayName = governorate.name.isNotEmpty
                      ? governorate.name
                      : governorate.nameEn;
                  return DropdownMenuItem<String>(
                    value: displayName,
                    child: Text(displayName),
                  );
                }).toList(),
                onChanged: widget.availableGovernorates.isEmpty
                    ? null
                    : (value) {
                        setState(() {
                          _selectedGovernorate = value;
                        });
                        if (value != null) {
                          widget.governorateController.text = value;
                        }
                      },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return Strings.governorateRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              CustomButton(text: Strings.save, onPressed: widget.onSignup),
            ],
          ],
        ),
      ),
    );
  }
}
