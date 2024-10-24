// lib/example_pages/bottom_nav_bar.dart

import 'package:app_mobile_plusroom/example_pages/example_pages.dart';
import 'package:app_mobile_plusroom/properties-searching/search-page.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    PropertiesPage(),
    AddPropertyPage(),
    MessagesPage(),
    ProfilePage(),
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
        selectedItemColor: Color(0xFF064789),
        unselectedItemColor: Color(0xFF000000),
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: 60.0,
              height: 35.0,
              decoration: BoxDecoration(
                color: Color(0xFF064789),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Center(
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
            label: 'Add Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
