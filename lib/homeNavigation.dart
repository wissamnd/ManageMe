import 'package:flutter/material.dart';
import 'homeScreen.dart';
import 'NavigationScreen.dart';
import 'theme.dart';


class Nav extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Nav> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomeScreen(),
    NavigationScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: AppTheme.textOne,
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title:Text("الصفحة الرئيسية"),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text("الملف الشخصي"),
          )
        ],
      ),
    );
  }

  void onTabTapped(int index){
    setState(() {
      _currentIndex = index;
    });
  }
}