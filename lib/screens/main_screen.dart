import 'package:flutter/material.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  final NotchBottomBarController _notchController = NotchBottomBarController(index: 0);

  final List<Widget> _pages = [
    const HomeScreen(),
    const ProfileScreen(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _notchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Allows the list/content to scroll behind the floating bar
      // 🚀 Replaced ConcentricPageView with a standard PageView
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Disables horizontal swiping
        children: _pages,
      ),
      bottomNavigationBar: AnimatedNotchBottomBar(
        notchBottomBarController: _notchController,
        color: Colors.white,
        showLabel: true,
        kIconSize: 24.0,
        kBottomRadius: 28.0,
        itemLabelStyle: const TextStyle(color: Colors.black, fontSize: 12),
        notchColor: const Color(0xFF8CC63F), // Light Green for the floating notch
        bottomBarItems: const [
          BottomBarItem(
            inActiveItem: Icon(Icons.home_outlined, color: Colors.grey),
            activeItem: Icon(Icons.home, color: Colors.white),
            itemLabel: 'Home',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.person_outline, color: Colors.grey),
            activeItem: Icon(Icons.person, color: Colors.white),
            itemLabel: 'Profile',
          ),
        ],
        onTap: (index) {
          // 🚀 Controls the routing between the pages
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300), // Quick, smooth fade/slide
            curve: Curves.easeInOut,
          );
        },
      ),
    );
  }
}