import 'package:flutter/material.dart';

/// Manages all form controllers for authentication screens
class AuthFormController {
  // Login form controllers
  final loginPhoneController = TextEditingController();
  final loginPasswordController = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();

  // Signup form controllers
  final signupNameController = TextEditingController();
  final signupPhoneController = TextEditingController(); // Phone for step 1
  final signupEmailController = TextEditingController(); // Email for step 1
  final signupPasswordController = TextEditingController();
  final signupFormKey = GlobalKey<FormState>();

  // Step 2 controllers
  final signupParentPhoneController = TextEditingController();
  final signupParentPhoneOptController = TextEditingController();
  final signupSchoolController = TextEditingController();
  final signupGovernorateController = TextEditingController();

  void dispose() {
    loginPhoneController.dispose();
    loginPasswordController.dispose();
    signupNameController.dispose();
    signupPhoneController.dispose();
    signupEmailController.dispose();
    signupPasswordController.dispose();
    signupParentPhoneController.dispose();
    signupParentPhoneOptController.dispose();
    signupSchoolController.dispose();
    signupGovernorateController.dispose();
  }

  void reset() {
    loginPhoneController.clear();
    loginPasswordController.clear();
    signupNameController.clear();
    signupPhoneController.clear();
    signupEmailController.clear();
    signupPasswordController.clear();
    signupParentPhoneController.clear();
    signupParentPhoneOptController.clear();
    signupSchoolController.clear();
    signupGovernorateController.clear();
  }
}
