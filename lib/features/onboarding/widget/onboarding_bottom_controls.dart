import 'package:flutter/material.dart';
import 'package:jesoor_pro/core/widgets/custom_text.dart';
import 'package:jesoor_pro/config/theme/app_colors.dart';
import '../onboarding_data.dart';
import 'onboarding_indicator.dart';

class OnboardingBottomControls extends StatelessWidget {
  final int currentPage;
  final VoidCallback onSkip;
  final VoidCallback onNext;

  const OnboardingBottomControls({
    super.key,
    required this.currentPage,
    required this.onSkip,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OutlinedButton(
            onPressed: onSkip,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const CustomText(
              'تخطي',
              color: AppColors.primary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),

          Row(
            children: List.generate(
              onboardingPages.length,
              (index) => OnboardingIndicator(isActive: index == currentPage),
            ),
          ),

          ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              elevation: 0,
            ),
            child: CustomText(
              currentPage == onboardingPages.length - 1 ? 'ابدأ' : 'التالي',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textWhite,
            ),
          ),
        ],
      ),
    );
  }
}
