import 'package:flutter/material.dart';
import 'package:jesoor_pro/roots_view.dart';
import 'package:jesoor_pro/core/theme/app_colors.dart';
import 'package:jesoor_pro/core/theme/app_dimensions.dart';

import 'widgets/auth_header.dart';
import 'widgets/auth_tab_bar.dart';
import 'widgets/login_form.dart';
import 'widgets/signup_form.dart';

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
  final _signupEmailController = TextEditingController();
  final _signupPasswordController = TextEditingController();

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
    super.dispose();
  }

  void _navigateToHome() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RootsView()),
    );
  }

  void _togglePasswordVisibility() {
    setState(() => _obscurePassword = !_obscurePassword);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const AuthHeader(),
            const SizedBox(height: 40),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppDimensions.topContainerRadius),
                    topRight: Radius.circular(AppDimensions.topContainerRadius),
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
                          SignupForm(
                            formKey: _signupFormKey,
                            nameController: _signupNameController,
                            emailController: _signupEmailController,
                            passwordController: _signupPasswordController,
                            obscurePassword: _obscurePassword,
                            onTogglePassword: _togglePasswordVisibility,
                            onSignup: _navigateToHome,
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
    );
  }
}
