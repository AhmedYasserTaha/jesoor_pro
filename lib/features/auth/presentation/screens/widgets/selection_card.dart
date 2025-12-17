import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:jesoor_pro/config/theme/app_colors.dart';
import 'package:jesoor_pro/config/theme/app_dimensions.dart';

class SelectionCard extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isSelected;

  const SelectionCard({
    super.key,
    required this.text,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: DashedBorderPainter(
          color: isSelected
              ? AppColors.primary
              : AppColors.primary.withOpacity(0.5),
          strokeWidth: isSelected ? 2.5 : 1.5,
          gap: 5.0,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withOpacity(0.15)
                : const Color(0xFFE3F2FD), // Light blue background
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? AppColors.primary : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.gap = 5.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final Path path = Path();
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(AppDimensions.borderRadius),
      ),
    );

    final Path dashedPath = _dashPath(path, dashWidth: 5.0, dashSpace: gap);
    canvas.drawPath(dashedPath, paint);
  }

  Path _dashPath(
    Path path, {
    required double dashWidth,
    required double dashSpace,
  }) {
    final Path dashedPath = Path();
    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        dashedPath.addPath(
          metric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }
    return dashedPath;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
