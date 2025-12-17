import 'package:flutter/material.dart';
import 'package:jesoor_pro/config/theme/app_colors.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep; // 1, 2, or 3

  const StepIndicator({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 20,
        bottom: 10,
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStepItem(1, "البيانات الشخصية", currentStep >= 1),
            _buildDashedLine(),
            _buildStepItem(2, "بيانات ولي الأمر", currentStep >= 2),
            _buildDashedLine(),
            _buildStepItem(3, "اختيار الصف", currentStep >= 3),
          ],
        ),
      ),
    );
  }

  Widget _buildStepItem(int step, String label, bool isActive) {
    return Column(
      children: [
        Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            "$step",
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey[600],
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 80, // Constrain width for wrapping
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.black : Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDashedLine() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(
          top: 17,
        ), // Align with center of box (35/2 approx)
        height: 1,
        child: CustomPaint(painter: _DashedLinePainter()),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 5, dashSpace = 3, startX = 0;
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 2;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
