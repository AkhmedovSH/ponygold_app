import 'package:flutter/material.dart';

import 'package:PonyGold/globals.dart' as globals;

class BottomNavigation extends StatefulWidget {
  final Function changeIndex;
  final int currentIndex;
  const BottomNavigation({Key? key, required this.changeIndex, required this.currentIndex}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  bool basketlength = false;
  bool ordersLength = false;

  void onSelectMenu(int index) async {
    widget.changeIndex(index);
  }

  @override
  void initState() {
    super.initState();
    basketlength = globals.basketlength;
    ordersLength = globals.ordersLength;
  }

  Widget circle = Positioned(
      top: 0,
      right: 0,
      child: Container(
        height: 10,
        width: 10,
        decoration: new BoxDecoration(
          color: Color(0xFFEB6465),
          shape: BoxShape.circle,
        ),
      ));

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: onSelectMenu,
        currentIndex: widget.currentIndex,
        backgroundColor: globals.white,
        selectedItemColor: globals.blue,
        selectedIconTheme: IconThemeData(color: globals.blue),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
              icon: Stack(children: [
                Icon(
                  Icons.shopping_cart_outlined,
                ),
                basketlength
                    ? circle
                    : Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          height: 10,
                          width: 10,
                          decoration: new BoxDecoration(
                            color: Colors.white.withOpacity(0),
                            shape: BoxShape.circle,
                          ),
                        ))
              ]),
              label: ''),
          BottomNavigationBarItem(
              icon: Stack(children: [
                Icon(
                  Icons.shopping_bag_outlined,
                ),
                ordersLength
                    ? circle
                    : Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          height: 10,
                          width: 10,
                          decoration: new BoxDecoration(
                            color: Colors.white.withOpacity(0),
                            shape: BoxShape.circle,
                          ),
                        ))
              ]),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              label: ''),
        ]);
  }
}
