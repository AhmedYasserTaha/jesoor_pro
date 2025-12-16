import 'package:flutter/material.dart';

class OnboardingIndicator extends StatelessWidget {
  final bool isActive;

  const OnboardingIndicator({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF092032) : Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
