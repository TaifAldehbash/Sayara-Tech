// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class BottomBar extends StatelessWidget {
  BottomBar({super.key, required this.activeItem});
  late double deviceWidth, deviceHeight;
  int activeItem = 0;
  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    return ConvexAppBar(
      style: TabStyle.reactCircle,
      backgroundColor: Color.fromARGB(255, 125, 190, 178),
      items: [
        TabItem(icon: Icons.car_repair, title: 'Cars'),
        TabItem(icon: Icons.add, title: 'New Car'),
        TabItem(icon: Icons.person, title: 'Profile'),
      ],
      initialActiveIndex: activeItem,
      onTap: (int i) {
        if (i == 0 && activeItem != 0) {
          Navigator.of(context).pushNamed('/Home');
        }
        if (i == 1 && activeItem != 1) {
          Navigator.of(context).pushNamed('/NewCar');
        }
        if (i == 2 && activeItem != 2) {
          Navigator.of(context).pushNamed('/Profile');
        }
      },
    );
  }
}
