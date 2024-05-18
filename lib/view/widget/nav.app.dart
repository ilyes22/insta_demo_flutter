import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:learn_bloc/view/screen/favorite.dart';
import 'package:learn_bloc/view/screen/home.dart';
import 'package:learn_bloc/view/screen/profile.dart';
import 'package:learn_bloc/view/screen/search.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _bottomNavIndex = 0;

  void changetScreen(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildScreen(), //destination screen
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      bottomNavigationBar: buildNavBar(),
    );
  }

  Widget buildNavBar() {
    return AnimatedBottomNavigationBar(
      icons: const [
        Icons.home,
        Icons.favorite,
        Icons.search,
        Icons.person,
      ],
      activeIndex: _bottomNavIndex,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.softEdge,
      onTap: changetScreen,
      inactiveColor: Colors.white54,
      activeColor: Colors.yellow,
      backgroundColor: Colors.black,
      blurEffect: true,
      elevation: 5,
      gapWidth: 5,
      rightCornerRadius: 10,
      leftCornerRadius: 10,
      splashColor: Colors.yellow,
      borderWidth: 5,
      iconSize: 25,
      splashRadius: 25,
    );
  }

  Widget buildScreen() {
    if (_bottomNavIndex == 1) {
      return const Favorite();
    } else if (_bottomNavIndex == 2) {
      return const Search();
    } else if (_bottomNavIndex == 3) {
      return const Profile();
    } else {
      return const Home();
    }
  }
}
