import 'package:flutter/material.dart';
import 'package:jesoor_pro/core/widgets/custom_text.dart';
import 'package:jesoor_pro/core/theme/app_colors.dart';

class AssignmentScreen extends StatelessWidget {
  const AssignmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 100,
              color: AppColors.primary,
            ),
            SizedBox(height: 20),
            const CustomText(
              'Assignment Screen',
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
