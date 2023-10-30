import 'package:flutter/material.dart';

class appBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(100.0);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppBar(
            elevation: 0.0,
            title: Text('Welcome', style: TextStyle(fontSize: 28)),
            toolbarHeight: 65,
            centerTitle: true,
          ),
        ],
      ),
    );
  }
}
