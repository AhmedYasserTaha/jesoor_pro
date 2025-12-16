import 'package:flutter/material.dart';
import 'package:jesoor_pro/core/widgets/custom_text.dart';
import 'package:jesoor_pro/config/theme/app_colors.dart';
import '../onboarding_data.dart';
import 'onboarding_title.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingData data;
  final int index;

  const OnboardingPage({super.key, required this.data, required this.index});

  @override
  Widget build(BuildContext context) {
    final bool isFirstPage = index == 0;
    final secondLineText = data.title.split('\n').length > 1
        ? data.title.split('\n')[1]
        : '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: isFirstPage
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          const SizedBox(height: 30),

          OnboardingTitle(
            title: data.title,
            index: index,
            isFirstPage: isFirstPage,
            secondLineText: secondLineText,
          ),

          const Spacer(flex: 2),

          // Illustration
          Center(
            child: Image.asset(
              data.imagePath,
              height: 320,
              width: 280,
              fit: BoxFit.contain,
            ),
          ),

          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
