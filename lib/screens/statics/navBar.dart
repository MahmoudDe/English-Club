import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class NavBar extends StatelessWidget {
  final Function(int) onTap;
  final int currentIndex;

  NavBar(this.onTap, this.currentIndex);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      child: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconSize: 25.0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Iconsax.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.search_normal),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.setting),
            label: '',
          ),
        ],
        currentIndex: currentIndex,
        onTap: onTap,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
