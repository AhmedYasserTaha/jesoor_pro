import 'package:flutter/material.dart';
import 'package:jesoor_pro/core/widgets/custom_text.dart';
import 'package:jesoor_pro/core/theme/app_colors.dart';

class PromoBanner extends StatelessWidget {
  const PromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  'Friday Sale',
                  color: AppColors.textWhite.withOpacity(0.8),
                  fontSize: 14,
                ),
                const SizedBox(height: 4),
                const CustomText(
                  'Up to 30% Off',
                  color: AppColors.textWhite,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.textWhite,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const CustomText(
                    'Shop Now',
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 120,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.textWhite.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              size: 50,
                    color: AppColors.background,
            ),
          ),
        ],
      ),
    );
  }
}
