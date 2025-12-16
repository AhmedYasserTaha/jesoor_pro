class EndPoints {
  static const String baseUrl = 'http://jesoor.semicolon-solution.net/api/';
  static const String sendOtp = 'auth/register/send-otp';
  static const String verifyOtp = 'auth/register/verify-otp';
  static const String login = 'auth/login';
  static const String loginSendOtp = 'auth/login/send-otp';
  static const String loginVerifyOtp = 'auth/login/verify-otp';
  static const String signup = 'auth/register';
  static const String completeStep2 = 'auth/register/complete-step2';
  static const String completeStep3 = 'auth/register/complete-step3';
  static const String categories = 'auth/categories';
  static String categoryChildren(int id) => 'auth/categories/$id/children';
  static const String governorates = 'auth/governorates';
  static const String validateDevice = 'auth/device/validate';
  static const String forgotPasswordSendOtp = 'auth/forgot-password/send-otp';
  static const String forgotPasswordReset = 'auth/forgot-password/reset';
}
