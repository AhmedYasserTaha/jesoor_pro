import 'package:flutter/material.dart';
import 'package:jesoor_pro/core/widgets/custom_text.dart';
import 'package:jesoor_pro/core/theme/app_colors.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.background,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: AppColors.backgroundGrey,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.brush_outlined,
                size: 60,
                color: AppColors.primary,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  'Product Name',
                  fontSize: 14,
                  color: const Color(0xFF092032),
                  fontWeight: FontWeight.w500,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                const CustomText(
                  '\$40.00',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
