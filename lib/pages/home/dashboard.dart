import 'dart:convert';
import 'package:PonyGold/pages/home/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:PonyGold/pages/home/profile.dart';
import 'package:PonyGold/pages/home/basket.dart';
import 'package:PonyGold/pages/home/index.dart';
import 'package:PonyGold/pages/home/orders.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  int? index;
  Dashboard({Key? key, this.index}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.index != null) {
      setState(() {
        currentIndex = widget.index!;
      });
    }
  }

  changeIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigation(
        changeIndex: changeIndex,
        currentIndex: currentIndex,
      ),
      body: IndexedStack(
        index: currentIndex,
        children: [
          Index(),
          Basket(),
          Orders(),
          Profile(),
        ],
      ),
      //screens[currentIndex]
    );
  }
}
