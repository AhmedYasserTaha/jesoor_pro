import 'package:flutter/material.dart';
import 'package:jesoor_pro/core/widgets/custom_text.dart';
import 'package:jesoor_pro/core/theme/app_colors.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomText(
                  'Hello',
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
                const CustomText('👋', fontSize: 16),
              ],
            ),
            const CustomText(
              'Jacob Jones',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.backgroundGrey,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.notifications_outlined,
            color: Color(0xFF092032),
          ),
        ),
      ],
    );
  }
}
