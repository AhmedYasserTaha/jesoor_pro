import 'package:flutter/material.dart';
import 'package:jesoor_pro/config/theme/app_dimensions.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/utils/strings.dart';
import 'package:jesoor_pro/features/auth/presentation/screens/widgets/selection_card.dart';
import 'package:jesoor_pro/features/auth/domain/entities/governorate_entity.dart';
import 'package:jesoor_pro/features/auth/domain/entities/category_entity.dart';
import 'package:jesoor_pro/features/auth/presentation/cubit/auth_state.dart';

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
  final Function(CategoryEntity)
  onCategorySelect; // For selecting parent category (step 3)
  final Function(CategoryEntity)
  onChildCategorySelect; // For selecting child category (step 4) - calls completeStep3

  // Data for selections
  final List<String> availableGrades; // passed from parent based on stage
  final List<GovernorateEntity> availableGovernorates; // passed from parent
  final List<CategoryEntity>
  availableCategories; // passed from parent - for step 3 (parent categories)
  final List<CategoryEntity>
  availableCategoryChildren; // passed from parent - for step 4 (child categories)

  // Loading states from AuthCubit
  final AuthStatus getCategoriesStatus; // Loading state for parent categories
  final AuthStatus
  getCategoryChildrenStatus; // Loading state for child categories

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
    required this.onChildCategorySelect,
    this.availableGrades = const [],
    this.availableGovernorates = const [],
    this.availableCategories = const [],
    this.availableCategoryChildren = const [],
    this.getCategoriesStatus = AuthStatus.initial,
    this.getCategoryChildrenStatus = AuthStatus.initial,
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
      // Show loading if categories are being fetched or if categories list is empty and status is loading
      final isLoadingCategories =
          widget.getCategoriesStatus == AuthStatus.loading ||
          (widget.availableCategories.isEmpty &&
              widget.getCategoriesStatus == AuthStatus.loading);
      final isLoadingChildren =
          widget.getCategoryChildrenStatus == AuthStatus.loading;

      return SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.formPadding),
        child: Stack(
          children: [
            Column(
              children: [
                if (isLoadingCategories && widget.availableCategories.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (widget.availableCategories.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text('لا توجد فئات متاحة'),
                    ),
                  )
                else
                  ...widget.availableCategories.map((category) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: SelectionCard(
                        text: category.name,
                        onTap: (isLoadingChildren || isLoadingCategories)
                            ? () {}
                            : () => widget.onCategorySelect(category),
                      ),
                    );
                  }).toList(),
              ],
            ),
            // Show loading overlay when fetching children after selecting a parent
            if (isLoadingChildren && widget.availableCategories.isNotEmpty)
              Positioned.fill(
                child: Container(
                  color: Colors.white.withOpacity(0.7),
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      );
    }

    if (widget.step == 4) {
      // Show loading if children categories are being fetched
      final isLoadingChildren =
          widget.getCategoryChildrenStatus == AuthStatus.loading;

      return SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.formPadding),
        child: Column(
          children: [
            if (isLoadingChildren && widget.availableCategoryChildren.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (widget.availableCategoryChildren.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text('لا توجد فئات فرعية متاحة'),
                ),
              )
            else
              ...widget.availableCategoryChildren.map((childCategory) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SelectionCard(
                    text: childCategory.name,
                    onTap: isLoadingChildren
                        ? () {}
                        : () => widget.onChildCategorySelect(childCategory),
                  ),
                );
              }).toList(),
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
