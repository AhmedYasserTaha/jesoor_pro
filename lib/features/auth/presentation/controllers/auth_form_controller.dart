import 'package:flutter/material.dart';

/// Manages all form controllers for authentication screens
class AuthFormController {
  // Login form controllers
  final loginPhoneController = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();

  // Signup form controllers
  final signupNameController = TextEditingController();
  final signupEmailController = TextEditingController();
  final signupPasswordController = TextEditingController();
  final signupFormKey = GlobalKey<FormState>();

  // Step 2 controllers
  final signupParentPhoneController = TextEditingController();
  final signupParentPhoneOptController = TextEditingController();
  final signupSchoolController = TextEditingController();
  final signupGovernorateController = TextEditingController();

  void dispose() {
    loginPhoneController.dispose();
    signupNameController.dispose();
    signupEmailController.dispose();
    signupPasswordController.dispose();
    signupParentPhoneController.dispose();
    signupParentPhoneOptController.dispose();
    signupSchoolController.dispose();
    signupGovernorateController.dispose();
  }

  void reset() {
    loginPhoneController.clear();
    signupNameController.clear();
    signupEmailController.clear();
    signupPasswordController.clear();
    signupParentPhoneController.clear();
    signupParentPhoneOptController.clear();
    signupSchoolController.clear();
    signupGovernorateController.clear();
  }
}
