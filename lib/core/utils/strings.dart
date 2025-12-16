class Strings {
  // App Info
  static const String appName = 'Jesoor Pro';
  static const String fontFamily = 'Tajawal';
  static const String noRouteFound = 'No Route Found';

  // Common
  static const String ok = 'OK';
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';
  static const String next = 'Next';
  static const String save = 'SAVE';
  static const String verify = 'VERIFY';
  static const String signup = 'SIGNUP';
  static const String login = 'LOGIN';

  // Auth - Login
  static const String phoneNumber = 'Phone number';
  static const String password = 'Password';
  static const String loginButton = 'Login';
  static const String forgotPassword = 'Forgot password ?';
  static const String phoneNumberRequired = 'Phone number is required';
  static const String enterValidEgyptianPhone =
      'Enter a valid Egyptian phone number';
  static const String passwordRequired = 'Password is required';
  static const String passwordMinLength =
      'Password must be at least 6 characters';

  // Auth - Signup
  static const String enterFullName = 'Enter Full Name';
  static const String nameRequired = 'Name is required';
  static const String parentPhone = 'Parent Phone';
  static const String parentPhoneOptional = 'Parent Phone (Optional)';
  static const String parentPhoneRequired = 'Parent Phone is required';
  static const String schoolName = 'School Name';
  static const String schoolNameRequired = 'School Name is required';
  static const String governorate = 'Governorate';
  static const String governorateRequired = 'Governorate is required';

  // Auth - OTP
  static const String verifyOtp = 'Verify OTP';
  static const String enterOtpCode = 'Enter the 6-digit code sent to\n';
  static const String otpIncorrect = 'OTP code is incorrect';
  static const String confirmPhoneNumber = 'Confirm Phone Number';
  static const String confirmPhoneMessage =
      'We will send an OTP code to {phone}.\nIs this correct?';
  static const String phoneAlreadyRegistered =
      'This phone number is already registered, cannot register with it again';

  // Auth - Forgot Password
  static const String forgotPasswordTitle = 'Forgot Password';
  static const String verifyCode = 'Verify Code';
  static const String resetPassword = 'Reset Password';
  static const String enterPhoneForOtp =
      'Enter your phone number to receive verification code';
  static const String enterNewPassword = 'Enter a new password';
  static const String newPassword = 'New Password';
  static const String confirmPassword = 'Confirm Password';
  static const String confirmPasswordRequired =
      'Password confirmation is required';
  static const String passwordsDoNotMatch = 'Passwords do not match';
  static const String sendCode = 'Send Code';
  static const String changePassword = 'Change Password';
  static const String passwordChangedSuccessfully =
      'Password changed successfully';
  static const String pleaseEnterPhoneNumber = 'Please enter a phone number';

  // Auth - Success
  static const String accountCreated =
      'I created a new account — congratulations 🎉';
  static const String accountCreatedMessage =
      'There are just a few simple steps left so you can start using your account.';

  // Errors
  static const String errorOccurred = 'An error occurred, please try again';
  static const String requestCancelled = 'Request cancelled';
  static const String noInternetConnection = 'No Internet Connection';

  // Roots Screen
  static const String home = 'Home';
  static const String search = 'Search';
  static const String favorites = 'Favorites';
  static const String profile = 'Profile';
  static const String welcomeToHome = 'Welcome to Home Page';

  // Education System
  static const String general = 'General';
  static const String azhar = 'Azhar';
  static const String languages = 'Languages';
  static const String primary = 'Primary';
  static const String preparatory = 'Preparatory';
  static const String secondary = 'Secondary';

  // Helper method to replace placeholders
  static String replacePlaceholder(
    String text,
    String placeholder,
    String value,
  ) {
    return text.replaceAll('{$placeholder}', value);
  }
}
