import 'package:flutter/material.dart';
import 'package:jesoor_pro/core/widgets/custom_text.dart';
import 'package:jesoor_pro/core/theme/app_colors.dart';
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
            child: Container(
              height: 320,
              width: 280,
              decoration: BoxDecoration(
                color: AppColors.backgroundGrey,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border, width: 2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_outlined,
                    size: 70,
                    color: AppColors.iconLight,
                  ),
                  const SizedBox(height: 12),
                  CustomText(
                    'Add your illustration here',
                    color: AppColors.textLight,
                    fontSize: 13,
                  ),
                ],
              ),
            ),
          ),

          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
