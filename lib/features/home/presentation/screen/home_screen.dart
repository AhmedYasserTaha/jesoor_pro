import 'package:flutter/material.dart';
import '../../widgets/home_header.dart';
import '../../widgets/search_bar_widget.dart';
import '../../widgets/promo_banner.dart';
import '../../widgets/section_header.dart';
import '../../widgets/subject_item.dart';
import '../../widgets/product_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                    return const SubjectItem();
                  },
                  itemCount: 8,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                ),
                const SizedBox(height: 16),

                // Just for you Section
                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    return const ProductItem();
                  },
                  itemCount: 6,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
