import 'package:flutter/material.dart';

class CategoriesBottomSheet extends StatelessWidget {
  const CategoriesBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CategoriesBottomSheet(),
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
              color: Colors.grey[300],
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
                  backgroundColor: Color(0xFF092032),
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Divy Jani',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF092032),
                      ),
                    ),
                    Text(
                      'Class 6 & Science | Roll no: 1',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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
                itemCount: 9,
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
      {
        'name': 'Attendance',
        'icon': Icons.calendar_today,
        'color': Color(0xFF4FC3F7),
      },
      {
        'name': 'Timetable',
        'icon': Icons.access_time,
        'color': Color(0xFF4FC3F7),
      },
      {
        'name': 'Notice Board',
        'icon': Icons.dashboard,
        'color': Color(0xFF4FC3F7),
      },
      {'name': 'Exams', 'icon': Icons.description, 'color': Color(0xFF4FC3F7)},
      {'name': 'Result', 'icon': Icons.assessment, 'color': Color(0xFF4FC3F7)},
      {
        'name': 'Report',
        'icon': Icons.insert_chart,
        'color': Color(0xFF4FC3F7),
      },
      {'name': 'Payment', 'icon': Icons.payment, 'color': Color(0xFF4FC3F7)},
      {'name': 'Academics', 'icon': Icons.school, 'color': Color(0xFF4FC3F7)},
      {'name': 'Settings', 'icon': Icons.settings, 'color': Color(0xFF4FC3F7)},
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              category['icon'] as IconData,
              size: 32,
              color: category['color'] as Color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            category['name'] as String,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF092032),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
