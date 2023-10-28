import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class NavBar extends StatelessWidget {
  final Function(int) onTap;
  final int currentIndex;

  NavBar(this.onTap, this.currentIndex);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.02),
              spreadRadius: 0.2,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
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
        ),
      ),
    );
  }
}
