import 'package:flutter/material.dart';
import '../widgets/home_header.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/promo_banner.dart';
import '../widgets/section_header.dart';
import '../widgets/subject_item.dart';
import '../widgets/product_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Map<String, String>> _subjects = const [
    {'image': 'assets/images/clipboard.png', 'label': 'Exams'},
    {'image': 'assets/images/files.png', 'label': 'Homework'},
    {'image': 'assets/images/folder.png', 'label': 'Materials'},
    {'image': 'assets/images/notes.png', 'label': 'Notes'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                const HomeHeader(),
                const SizedBox(height: 20),

                // Search Bar
                const SearchBarWidget(),
                const SizedBox(height: 20),

                // Promotional Banner
                const PromoBanner(),
                const SizedBox(height: 24),
                const SectionHeader(title: 'Subjects'),
                const SizedBox(height: 10),

                // Categories Section
                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    return SubjectItem(
                      imagePath: _subjects[index]['image']!,
                      label: _subjects[index]['label']!,
                    );
                  },
                  itemCount: _subjects.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
