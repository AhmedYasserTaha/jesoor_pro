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
    imagePath: 'assets/images/onboarding1.png', // User will add actual image
  ),
  OnboardingData(
    title: 'Learning\nMade Easy',
    description:
        'Learn at your own pace with interactive content and expert guidance',
    imagePath: 'assets/images/onboarding2.png', // User will add actual image
  ),
];
