class OnboardingData {
  final String title;
  final String description;
  final String imagePath;

  OnboardingData({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}

// بيانات صفحات الإعداد
final List<OnboardingData> onboardingPages = [
  OnboardingData(
    title: 'استكشف الدورات\nعبر الإنترنت',
    description:
        'اكتشف مجموعة واسعة من الدورات المصممة لتلبية احتياجاتك التعليمية',
    imagePath: 'assets/images/undraw_certificate_cqps.png',
  ),
  OnboardingData(
    title: 'التعلم\nبسهولة',
    description: 'تعلم وفقًا لسرعتك الخاصة مع محتوى تفاعلي وإرشاد من خبراء',
    imagePath: 'assets/images/undraw_terms_sx63.png',
  ),
];
