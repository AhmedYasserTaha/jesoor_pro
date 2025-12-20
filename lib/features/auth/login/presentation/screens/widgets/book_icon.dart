import 'package:flutter/material.dart';
import 'package:jesoor_pro/config/theme/app_colors.dart';

class BookIcon extends StatelessWidget {
  const BookIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.accentYellow,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          // Book pages effect
          Positioned(
            left: 0,
            right: 0,
            top: 12,
            bottom: 12,
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(color: AppColors.primary, width: 3),
                ),
              ),
            ),
          ),
          // Book lines
          Positioned(
            left: 20,
            right: 20,
            top: 25,
            child: Column(
              children: List.generate(
                4,
                (index) => Padding(
                  padding: EdgeInsets.only(bottom: index < 3 ? 6 : 0),
                  child: Container(height: 2, color: AppColors.primary),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
