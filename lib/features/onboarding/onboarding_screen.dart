import 'package:flutter/material.dart';
import 'package:jesoor_pro/config/routes/app_router.dart';
import 'package:jesoor_pro/config/routes/routes.dart';
import 'package:jesoor_pro/features/onboarding/widget/onboarding_bottom_controls.dart';
import 'package:jesoor_pro/features/onboarding/widget/onboarding_page.dart';
import 'onboarding_data.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) => setState(() => _currentPage = page);

  void _navigateToAuth() {
    Navigator.of(context).pushReplacementNamed(Routes.authScreen);
  }

  void _nextPage() {
    if (_currentPage < onboardingPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToAuth();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: onboardingPages.length,
                itemBuilder: (context, index) {
                  return OnboardingPage(
                    data: onboardingPages[index],
                    index: index,
                  );
                },
              ),
            ),

            OnboardingBottomControls(
              currentPage: _currentPage,
              onSkip: _navigateToAuth,
              onNext: _nextPage,
            ),
          ],
        ),
      ),
    );
  }
}
