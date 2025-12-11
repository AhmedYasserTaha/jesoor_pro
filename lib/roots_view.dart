import 'package:flutter/material.dart';
import 'package:jesoor_pro/features/menu/categories_bottom_sheet.dart';
import 'features/home/presentation/screen/home_screen.dart';
import 'features/chat/chat_screen.dart';
import 'features/assignment/assignment_screen.dart';

class RootsView extends StatefulWidget {
  const RootsView({super.key});

  @override
  State<RootsView> createState() => _RootsViewState();
}

class _RootsViewState extends State<RootsView> {
  int _currentIndex = 0;

  // قائمة الشاشات (بدون Menu لأنه bottom sheet)
  final List<Widget> _screens = const [
    HomeScreen(),
    ChatScreen(),
    AssignmentScreen(),
  ];

  void _onNavTap(int index) {
    // Index 3 is Menu - show bottom sheet instead
    if (index == 3) {
      MenuBottomSheet.show(context);
      return;
    }

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF092032),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onNavTap,
            type: BottomNavigationBarType.fixed,
            backgroundColor: const Color(0xFF092032),
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withOpacity(0.5),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline),
                activeIcon: Icon(Icons.chat_bubble),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.assignment_outlined),
                activeIcon: Icon(Icons.assignment),
                label: 'Assignment',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu),
                activeIcon: Icon(Icons.menu),
                label: 'Menu',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
