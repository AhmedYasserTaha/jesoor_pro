import 'package:flutter/material.dart';
import 'package:jesoor_pro/core/widgets/custom_text.dart';
import 'package:jesoor_pro/core/theme/app_colors.dart';

class MenuBottomSheet extends StatelessWidget {
  const MenuBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const MenuBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.iconLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primary,
                  child: const Icon(Icons.person, color: AppColors.textWhite),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      'Divy Jani',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                    CustomText(
                      'Class 6 & Science | Roll no: 1',
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Categories Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return _buildCategoryItem(index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(int index) {
    final categories = [
      {'name': 'Subject', 'icon': Icons.subject, 'color': AppColors.primary},
      {'name': 'Quiz', 'icon': Icons.quiz, 'color': AppColors.primary},
      {
        'name': 'Assignment',
        'icon': Icons.assignment,
        'color': AppColors.primary,
      },
      {'name': 'Live', 'icon': Icons.video_library, 'color': AppColors.primary},
      {'name': 'My Courses', 'icon': Icons.book, 'color': AppColors.primary},
    ];

    final category = categories[index];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              category['icon'] as IconData,
              size: 32,
              color: category['color'] as Color,
            ),
          ),
          const SizedBox(height: 8),
          CustomText(
            category['name'] as String,
            textAlign: TextAlign.center,
            fontSize: 12,
            color: AppColors.primary,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
