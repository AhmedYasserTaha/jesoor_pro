import 'package:flutter/material.dart';
import 'package:jesoor_pro/core/widgets/custom_text.dart';
import 'package:jesoor_pro/core/theme/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText('Profile', color: AppColors.textWhite),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textWhite,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_outline, size: 100, color: AppColors.primary),
            const SizedBox(height: 20),
            const CustomText(
              'Profile Screen',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
