class Strings {
  // App Info
  static const String appName = 'Jesoor Pro';
  static const String fontFamily = 'Tajawal';
  static const String noRouteFound = 'الصفحة غير موجودة';

  // Common
  static const String ok = 'موافق';
  static const String cancel = 'إلغاء';
  static const String confirm = 'تأكيد';
  static const String next = 'التالي';
  static const String back = 'رجوع';
  static const String save = 'حفظ';
  static const String verify = 'تحقق';
  static const String signup = 'إنشاء حساب';
  static const String login = 'تسجيل الدخول';

  // Auth - Login
  static const String phoneNumber = 'رقم الهاتف';
  static const String password = 'كلمة المرور';
  static const String loginButton = 'تسجيل الدخول';
  static const String forgotPassword = 'نسيت كلمة المرور؟';
  static const String phoneNumberRequired = 'رقم الهاتف مطلوب';
  static const String enterValidEgyptianPhone = 'يرجى إدخال رقم هاتف مصري صحيح';
  static const String passwordRequired = 'كلمة المرور مطلوبة';
  static const String passwordMinLength =
      'كلمة المرور يجب أن تكون 6 أحرف على الأقل';

  // Auth - Signup
  static const String enterFullName = 'أدخل الاسم الكامل';
  static const String nameRequired = 'الاسم مطلوب';
  static const String parentPhone = 'هاتف ولي الأمر';
  static const String parentPhoneOptional = 'هاتف ولي الأمر (اختياري)';
  static const String parentPhoneRequired = 'هاتف ولي الأمر مطلوب';
  static const String schoolName = 'اسم المدرسة';
  static const String schoolNameRequired = 'اسم المدرسة مطلوب';
  static const String governorate = 'المحافظة';
  static const String governorateRequired = 'المحافظة مطلوبة';

  // Auth - OTP
  static const String verifyOtp = 'التحقق من رمز OTP';
  static const String enterOtpCode =
      'أدخل الرمز المكون من 6 أرقام المرسل إلى\n';
  static const String otpIncorrect = 'رمز OTP غير صحيح';
  static const String confirmPhoneNumber = 'تأكيد رقم الهاتف';
  static const String confirmPhoneMessage =
      'سنرسل رمز OTP إلى {phone}.\nهل هذا صحيح؟';
  static const String phoneAlreadyRegistered =
      'رقم الهاتف هذا مسجل بالفعل، لا يمكن التسجيل به مرة أخرى';

  // Auth - Forgot Password
  static const String forgotPasswordTitle = 'نسيت كلمة المرور';
  static const String verifyCode = 'التحقق من الرمز';
  static const String resetPassword = 'إعادة تعيين كلمة المرور';
  static const String enterPhoneForOtp = 'أدخل رقم هاتفك لتلقي رمز التحقق';
  static const String enterNewPassword = 'أدخل كلمة مرور جديدة';
  static const String newPassword = 'كلمة المرور الجديدة';
  static const String confirmPassword = 'تأكيد كلمة المرور';
  static const String confirmPasswordRequired = 'تأكيد كلمة المرور مطلوب';
  static const String passwordsDoNotMatch = 'كلمات المرور غير متطابقة';
  static const String sendCode = 'إرسال الرمز';
  static const String changePassword = 'تغيير كلمة المرور';
  static const String passwordChangedSuccessfully =
      'تم تغيير كلمة المرور بنجاح';
  static const String pleaseEnterPhoneNumber = 'يرجى إدخال رقم الهاتف';

  // Auth - Success
  static const String accountCreated = 'تم إنشاء حساب جديد — تهانينا 🎉';
  static const String accountCreatedMessage =
      'هناك خطوات بسيطة فقط متبقية حتى تتمكن من البدء في استخدام حسابك.';

  // Errors
  static const String errorOccurred = 'حدث خطأ، يرجى المحاولة مرة أخرى';
  static const String requestCancelled = 'تم إلغاء الطلب';
  static const String noInternetConnection = 'لا يوجد اتصال بالإنترنت';

  // Roots Screen
  static const String home = 'الرئيسية';
  static const String search = 'البحث';
  static const String favorites = 'المفضلة';
  static const String profile = 'الملف الشخصي';
  static const String welcomeToHome = 'مرحباً بك في الصفحة الرئيسية';

  // Education System
  static const String general = 'عام';
  static const String azhar = 'أزهر';
  static const String languages = 'لغات';
  static const String primary = 'ابتدائي';
  static const String preparatory = 'إعدادي';
  static const String secondary = 'ثانوي';

  // Helper method to replace placeholders
  static String replacePlaceholder(
    String text,
    String placeholder,
    String value,
  ) {
    return text.replaceAll('{$placeholder}', value);
  }
}
