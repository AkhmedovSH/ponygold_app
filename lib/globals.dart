library PonyGold.globals;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:PonyGold/pages/orders.dart';
import 'package:simple_moment/simple_moment.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:page_transition/page_transition.dart';
import 'package:PonyGold/pages/profile.dart';

String otp = '';
String phone = '';
bool loading = false;
double latitude = 0.0;
double longitude = 0.0;
int id = 1;

formatNumber(number) {
  if (number.length <= 3) {
    return number;
  }
  if (number.length == 4) {
    var x = number.substring(0, 1);
    final y = number.substring(1, 4);
    return x + ' ' + y;
  }
  if (number.length == 5) {
    var x = number.substring(0, 2);
    final y = number.substring(2, 5);
    return x + ' ' + y;
  }
  if (number.length == 6) {
    var x = number.substring(0, 3);
    final y = number.substring(3, 6);
    return x + ' ' + y;
  }
  if (number.length == 7) {
    var x = number.substring(0, 1);
    final y = number.substring(1, 4);
    final z = number.substring(4, 7);
    return x + ' ' + y + ' ' + z;
  }
  if (number.length == 8) {
    var x = number.substring(0, 2);
    final y = number.substring(2, 5);
    final z = number.substring(5, 8);
    return x + ' ' + y + ' ' + z;
  }
  if (number.length == 9) {
    var x = number.substring(0, 3);
    final y = number.substring(3, 6);
    final z = number.substring(6, 9);
    return x + ' ' + y + ' ' + z;
  }
  if (number.length == 10) {
    var x = number.substring(0, 1);
    final y = number.substring(1, 4);
    final z = number.substring(4, 7);
    final d = number.substring(7, 10);
    return x + ' ' + y + ' ' + z + ' ' + d;
  }
  if (number.length == 11) {
    var x = number.substring(0, 2);
    final y = number.substring(2, 5);
    final z = number.substring(5, 8);
    final d = number.substring(8, 11);
    return x + ' ' + y + ' ' + z + ' ' + d;
  }
  if (number.length == 12) {
    var x = number.substring(0, 3);
    final y = number.substring(3, 6);
    final z = number.substring(6, 9);
    final d = number.substring(9, 12);
    return x + ' ' + y + ' ' + z + ' ' + d;
  }
  return number;
}

Widget button = Container(
  height: 48,
  width: 144,
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(),
    onPressed: () {},
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(right: 8),
          child: Text(
            'Бонусные',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Image.asset('images/bonus.png')
      ],
    ),
  ),
);

showToast(context, error) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      // action: SnackBarAction(
      //   label: 'OK',
      //   textColor: Colors.white,
      //   onPressed: () {
      //     // Some code to undo the change.
      //   },
      // ),
      backgroundColor: Color(0xFFEB6465),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(error),
          Icon(
            Icons.arrow_downward,
            color: Colors.white,
            size: 16,
          )
        ],
      ),

      duration: Duration(milliseconds: 5000),
      width: 300, // Width of the SnackBar.
      padding: EdgeInsets.symmetric(
        horizontal: 8.0, // Inner padding for SnackBar content.
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
    ),
  );
}

int active = 0;

onItemTab(int index) {
  active = index;
  bottomBar = BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      currentIndex: active,
      showUnselectedLabels: false,
      // selectedItemColor: Color(0xFF5986E2),
      // unselectedItemColor: Colors.black,
      onTap: onItemTab,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home,
              color: active == 0 ? Color(0xFF5986E2) : Color(0xFF828282)),
          label: '',
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.manage_search,
                color: active == 1 ? Color(0xFF5986E2) : Color(0xFF828282)),
            label: ''),
        BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined,
                color: active == 2 ? Color(0xFF5986E2) : Color(0xFF828282)),
            label: ''),
        BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined,
                color: active == 3 ? Color(0xFF5986E2) : Color(0xFF828282)),
            label: ''),
        BottomNavigationBarItem(
            icon: Icon(Icons.person,
                color: active == 4 ? Color(0xFF5986E2) : Color(0xFF828282)),
            label: ''),
      ]);
  switch (index) {
    case 0:
      Get.offAllNamed("/");
      break;
    case 1:
      Get.toNamed("/orders");
      break;
    case 2:
      Get.toNamed(
        "/basket",
      );
      break;
    case 3:
      Get.toNamed("/orders");
      break;
    case 4:
      Get.toNamed("/profile");
      break;
  }
}

Widget bottomBar = BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    showSelectedLabels: false,
    currentIndex: active,
    showUnselectedLabels: false,
    // selectedItemColor: Color(0xFF5986E2),
    // unselectedItemColor: Colors.black,
    onTap: onItemTab,
    items: [
      BottomNavigationBarItem(
        icon: Icon(Icons.home,
            color: active == 0 ? Color(0xFF5986E2) : Color(0xFF828282)),
        label: '',
      ),
      BottomNavigationBarItem(
          icon: Icon(Icons.manage_search,
              color: active == 1 ? Color(0xFF5986E2) : Color(0xFF828282)),
          label: ''),
      BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined,
              color: active == 2 ? Color(0xFF5986E2) : Color(0xFF828282)),
          label: ''),
      BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag_outlined,
              color: active == 3 ? Color(0xFF5986E2) : Color(0xFF828282)),
          label: ''),
      BottomNavigationBarItem(
          icon: Icon(Icons.person,
              color: active == 4 ? Color(0xFF5986E2) : Color(0xFF828282)),
          label: ''),
    ]);

formatDate(date) {
  Moment rawDate = Moment.parse(date);
  return rawDate.format("dd.MM.yyyy HH:mm");
}

formatPhone(phone) {
  var x = phone.substring(0, 3);
  var y = phone.substring(3, 5);
  var z = phone.substring(5, 8);
  var d = phone.substring(8, 10);
  var q = phone.substring(10, 12);
  return '+' + x + ' ' + y + ' ' + z + ' ' + d + ' ' + q;
}
