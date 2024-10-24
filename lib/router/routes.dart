import 'package:app_mobile_plusroom/example_pages/example_pages.dart';
import 'package:app_mobile_plusroom/properties-searching/search-page.dart';
import 'package:flutter/material.dart';
import 'package:app_mobile_plusroom/ui-profile/profile_view.dart';
import 'package:app_mobile_plusroom/ui-initial-section/welcome_view.dart';

class BottomNavBar extends StatefulWidget {
  static String id = 'nav_bar';
  const BottomNavBar({super.key});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0; // Inicializa en 0 por defecto

  final List<Widget> _pages = [
    const WelcomeView(),
    const PropertiesPage(),
    const AddPropertyPage(),
    const MessagesPage(),
    const ProfileView(),
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onTap,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF064789),
        unselectedItemColor: const Color(0xFF000000),
        showUnselectedLabels: false,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: 60.0,
              height: 35.0,
              decoration: BoxDecoration(
                color: const Color(0xFF064789),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: const Center(
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
            label: 'Add Post',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
