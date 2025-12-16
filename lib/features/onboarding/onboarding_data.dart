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

// Onboarding pages data
final List<OnboardingData> onboardingPages = [
  OnboardingData(
    title: 'Explore Online\nCourses',
    description:
        'Discover a wide range of courses tailored to your learning needs',
    imagePath: 'assets/images/undraw_certificate_cqps.png',
  ),
  OnboardingData(
    title: 'Learning\nMade Easy',
    description:
        'Learn at your own pace with interactive content and expert guidance',
    imagePath: 'assets/images/undraw_terms_sx63.png',
  ),
];
