import 'package:flutter/material.dart';
import 'package:jesoor_pro/config/theme/app_colors.dart';
import 'package:jesoor_pro/core/utils/strings.dart';

class RootsScreen extends StatefulWidget {
  const RootsScreen({super.key});

  @override
  State<RootsScreen> createState() => _RootsScreenState();
}

class _RootsScreenState extends State<RootsScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const PlaceholderScreen(title: 'الشاشة 2'),
    const PlaceholderScreen(title: 'الشاشة 3'),
    const PlaceholderScreen(title: 'الشاشة 4'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: Strings.home),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: Strings.search,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: Strings.favorites,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: Strings.profile,
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.home),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(Strings.welcomeToHome, style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(child: Text(title, style: const TextStyle(fontSize: 24))),
    );
  }
}
