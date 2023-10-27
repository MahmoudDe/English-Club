import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

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
            title: Text('Welcome',
            style: TextStyle(fontSize: 28)
            ),
            toolbarHeight: 65,
            centerTitle: true,
            leading: Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: IconButton(
                icon: Icon(Iconsax.menu_1,size: 30.0),
                onPressed: () {
                },
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: IconButton(
                  icon: Icon(Iconsax.search_normal_1), // This is the Search icon
                  onPressed: () {
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
