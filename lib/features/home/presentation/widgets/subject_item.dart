import 'package:flutter/material.dart';

class SubjectItem extends StatelessWidget {
  const SubjectItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xffe8f0fb),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.subject, size: 32, color: Color(0xFF092032)),
          const SizedBox(height: 8),
          const Text(
            'Subject',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Color(0xFF092032)),
          ),
        ],
      ),
    );
  }
}
