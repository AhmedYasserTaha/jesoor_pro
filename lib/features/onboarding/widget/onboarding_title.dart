import 'package:flutter/material.dart';
import 'package:jesoor_pro/core/widgets/custom_text.dart';
import 'package:jesoor_pro/config/theme/app_colors.dart';

class OnboardingTitle extends StatelessWidget {
  final String title;
  final int index;
  final bool isFirstPage;
  final String secondLineText;

  const OnboardingTitle({
    super.key,
    required this.title,
    required this.index,
    required this.isFirstPage,
    required this.secondLineText,
  });

  @override
  Widget build(BuildContext context) {
    final firstLine = title.split('\n')[0];

    return Column(
      crossAxisAlignment: isFirstPage
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.end,
      children: [
        CustomText(
          firstLine,
          textAlign: isFirstPage ? TextAlign.left : TextAlign.right,
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),

        SizedBox(
          height: 26 * 1.2,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Align(
                alignment: isFirstPage
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: CustomText(
                  secondLineText,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),

              Positioned(
                left: isFirstPage ? null : -30,
                right: isFirstPage ? -30 : null,
                top: (26 * 1.2 - 2) / 2,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final screenWidth = MediaQuery.of(context).size.width;

                    final textPainter = TextPainter(
                      text: TextSpan(
                        text: secondLineText,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      textDirection: TextDirection.ltr,
                    );
                    textPainter.layout();
                    final textWidth = textPainter.size.width;

                    final lineWidth = screenWidth - 30 - textWidth - 8;

                    return Container(
                      width: lineWidth,
                      height: 2,
                      color: AppColors.primary,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
