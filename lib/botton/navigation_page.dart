
import 'package:flutter/material.dart';
import 'package:thriftpoint/screen/favorite_screen.dart';
import 'package:thriftpoint/screen/home_screen.dart';
import 'package:thriftpoint/screen/profile_screen.dart';
import 'package:thriftpoint/screen/search_screen.dart';



class BottomNavigationBarPage extends StatefulWidget {
  const BottomNavigationBarPage({super.key, required String title});

  @override
  State<BottomNavigationBarPage> createState() => _BottomNavigationBarPageState();
}
  
class _BottomNavigationBarPageState extends State<BottomNavigationBarPage> {
  
  int myCurrentIndex = 0;

  List screens =  [
    HomeScreen(),
    SearchScreen(),
    FavoriteScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      bottomNavigationBar: NavigationBar(destinations: const [
        NavigationDestination(icon: Icon(Icons.home_outlined),selectedIcon: Icon(Icons.home, color: Colors.black), label: 'Home',),
        NavigationDestination(icon: Icon(Icons.search_outlined),selectedIcon: Icon(Icons.search, color: Colors.black),label: 'Search',),
        NavigationDestination(icon: Icon(Icons.favorite_outlined),selectedIcon: Icon(Icons.favorite, color: Colors.black), label: 'Favorite',),
        NavigationDestination(icon: Icon(Icons.person_outlined),selectedIcon: Icon(Icons.person, color: Colors.black), label: 'Profile',),
        ],
        selectedIndex: myCurrentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            myCurrentIndex = index;
          });
        },
        backgroundColor: Colors.white,
        animationDuration: Duration(milliseconds: 1000),
        indicatorColor: Colors.transparent, //  ซ่อนกรอบสีม่วง
       // labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        ),
        body: screens[myCurrentIndex]);
  }
}