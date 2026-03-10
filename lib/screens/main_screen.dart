import 'package:flutter/material.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'home_screen.dart';
import 'recipe_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _pageController = PageController(initialPage: 1);
  final NotchBottomBarController _notchController = NotchBottomBarController(
    index: 1,
  );

  final List<Widget> _pages = [
    const RecipeScreen(),
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
      extendBody: true,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: AnimatedNotchBottomBar(
        notchBottomBarController: _notchController,
        color: Colors.white,
        showLabel: true,
        kIconSize: 24.0,
        kBottomRadius: 28.0,
        itemLabelStyle: const TextStyle(color: Colors.black, fontSize: 12),
        notchColor: const Color(0xFF8CC63F),
        bottomBarItems: const [
          BottomBarItem(
            inActiveItem: Icon(Icons.restaurant_menu, color: Colors.grey),
            activeItem: Icon(Icons.restaurant_menu, color: Colors.white),
            itemLabel: 'Recipe',
          ),
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
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
      ),
    );
  }
}
