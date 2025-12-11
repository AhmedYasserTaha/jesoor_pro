import 'package:flutter/material.dart';

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
                Text(
                  'Hello',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const Text('👋', style: TextStyle(fontSize: 16)),
              ],
            ),
            const Text(
              'Jacob Jones',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF092032),
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
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
