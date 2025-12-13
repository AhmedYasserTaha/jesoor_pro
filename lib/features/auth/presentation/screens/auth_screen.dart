import 'package:flutter/material.dart';
import 'package:jesoor_pro/core/widgets/custom_text.dart';
import 'package:jesoor_pro/roots_view.dart';
import 'package:jesoor_pro/core/theme/app_colors.dart';
import 'package:jesoor_pro/core/theme/app_dimensions.dart';

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

  bool _obscurePassword = true;

  final _loginFormKey = GlobalKey<FormState>();
  final _signupFormKey = GlobalKey<FormState>();

  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();

  final _signupNameController = TextEditingController();
  final _signupEmailController =
      TextEditingController(); // This is phone number in UI "hintText: 'Phone number'"
  final _signupPasswordController = TextEditingController();

  // Step 2 Controllers
  final _signupParentPhoneController = TextEditingController();
  final _signupParentPhoneOptController = TextEditingController();
  final _signupSchoolController = TextEditingController();
  final _signupGovernorateController = TextEditingController();

  int _signupStep = 1;

  // Step 3, 4, 5 Selections
  String? _educationSystem;
  String? _educationStage;
  String? _educationGrade;
  List<String> _availableGrades = [];

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

  void _navigateToHome() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RootsView()),
    );
  }

  void _handleSignup() {
    if (_signupStep == 1) {
      if (_signupFormKey.currentState!.validate()) {
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
                    Navigator.pop(context);
                    setState(() {
                      _signupStep = 2;
                    });
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
      }
    } else if (_signupStep == 2) {
      if (_signupFormKey.currentState!.validate()) {
        // Advance to Step 3 (System Selection)
        setState(() {
          _signupStep = 3;
        });
      }
    } else if (_signupStep == 5) {
      // Final Step
      _navigateToHome();
    }
  }

  void _onSystemSelect(String system) {
    setState(() {
      _educationSystem = system;
      _signupStep = 4; // Advance to Stage
    });
  }

  void _onStageSelect(String stage) {
    setState(() {
      _educationStage = stage;
      _updateAvailableGrades(stage);
      _signupStep = 5; // Advance to Grade
    });
  }

  void _onGradeSelect(String grade) {
    setState(() {
      _educationGrade = grade;
      _navigateToHome(); // Finish
    });
  }

  void _updateAvailableGrades(String stage) {
    if (stage == 'Primary') {
      _availableGrades = List.generate(6, (i) => '${i + 1} Primary');
    } else if (stage == 'Preparatory') {
      _availableGrades = List.generate(3, (i) => '${i + 1} Preparatory');
    } else if (stage == 'Secondary') {
      _availableGrades = List.generate(3, (i) => '${i + 1} Secondary');
    } else {
      _availableGrades = [];
    }
  }

  void _togglePasswordVisibility() {
    setState(() => _obscurePassword = !_obscurePassword);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
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
                      topLeft: Radius.circular(
                        AppDimensions.topContainerRadius,
                      ),
                      topRight: Radius.circular(
                        AppDimensions.topContainerRadius,
                      ),
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
                              obscurePassword: _obscurePassword,
                              onTogglePassword: _togglePasswordVisibility,
                              onLogin: _navigateToHome,
                            ),
                            Column(
                              children: [
                                StepIndicator(
                                  currentStep: _signupStep >= 3
                                      ? 3
                                      : _signupStep,
                                ),
                                Expanded(
                                  child: SignupForm(
                                    formKey: _signupFormKey,
                                    nameController: _signupNameController,
                                    emailController: _signupEmailController,
                                    passwordController:
                                        _signupPasswordController,
                                    obscurePassword: _obscurePassword,
                                    onTogglePassword: _togglePasswordVisibility,
                                    onSignup: _handleSignup,
                                    step: _signupStep,
                                    parentPhoneController:
                                        _signupParentPhoneController,
                                    parentPhoneOptController:
                                        _signupParentPhoneOptController,
                                    schoolController: _signupSchoolController,
                                    governorateController:
                                        _signupGovernorateController,
                                    onSystemSelect: _onSystemSelect,
                                    onStageSelect: _onStageSelect,
                                    onGradeSelect: _onGradeSelect,
                                    availableGrades: _availableGrades,
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
        ),
      ),
    );
  }
}
