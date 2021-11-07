library PonyGold.globals;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_moment/simple_moment.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

String otp = '';
String phone = '';
String lang = 'ru';
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
          vertical: 8.0),
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
  switch (index) {
    case 0:
      Get.offAllNamed("/");
      break;
    // case 1:
    //   Get.offAllNamed("/search");
    //   break;
    case 1:
      Get.offAllNamed(
        "/basket",
      );
      break;
    case 2:
      Get.offAllNamed("/orders");
      break;
    case 3:
      Get.offAllNamed("/profile");
      break;
  }
  bottomBar = BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      currentIndex: active,
      showUnselectedLabels: false,
      // selectedItemColor: Colors.red,
      // unselectedItemColor: Colors.black,
      onTap: onItemTab,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home,
              color: active == 0 ? Color(0xFF5986E2) : Color(0xFF828282)),
          label: '',
        ),
        BottomNavigationBarItem(
            icon: Stack(children: [
              Icon(Icons.shopping_cart_outlined,
                  color: active == 1 ? Color(0xFF5986E2) : Color(0xFF828282)),
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
            icon: Stack(
              children: [
                Icon(Icons.shopping_bag_outlined,
                    color: active == 2 ? Color(0xFF5986E2) : Color(0xFF828282)),
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
              ],
            ),
            label: ''),
        BottomNavigationBarItem(
            icon: Icon(Icons.person,
                color: active == 3 ? Color(0xFF5986E2) : Color(0xFF828282)),
            label: ''),
      ]);
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
          icon: Stack(children: [
            Icon(Icons.shopping_cart_outlined,
                color: active == 1 ? Color(0xFF5986E2) : Color(0xFF828282)),
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
          icon: Stack(
            children: [
              Icon(Icons.shopping_bag_outlined,
                  color: active == 2 ? Color(0xFF5986E2) : Color(0xFF828282)),
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
            ],
          ),
          label: ''),
      BottomNavigationBarItem(
          icon: Icon(Icons.person,
              color: active == 3 ? Color(0xFF5986E2) : Color(0xFF828282)),
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

bool basketlength = false;
bool ordersLength = false;

checkLength(check) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (check == 1 || check == 3) {
    dynamic basket = prefs.getStringList('basket');
    basketlength = basket.length > 0;
  }
  if (check == 2 || check == 3) {
    dynamic token = prefs.getString('access_token');
    final response = await http.get(
      Uri.parse('https://ponygold.uz/api/client/user-orders'),
      headers: {
        // HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    final responseJson = await jsonDecode(response.body);
    ordersLength = responseJson['data'].length > 0;
  }
  bottomBar = BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      currentIndex: active,
      showUnselectedLabels: false,
      onTap: onItemTab,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home,
              color: active == 0 ? Color(0xFF5986E2) : Color(0xFF828282)),
          label: '',
        ),
        // BottomNavigationBarItem(
        //     icon: Icon(Icons.manage_search,
        //         color: active == 1 ? Color(0xFF5986E2) : Color(0xFF828282)),
        //     label: ''),
        BottomNavigationBarItem(
            icon: Stack(children: [
              Icon(Icons.shopping_cart_outlined,
                  color: active == 1 ? Color(0xFF5986E2) : Color(0xFF828282)),
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
            icon: Stack(
              children: [
                Icon(Icons.shopping_bag_outlined,
                    color: active == 2 ? Color(0xFF5986E2) : Color(0xFF828282)),
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
              ],
            ),
            label: ''),
        BottomNavigationBarItem(
            icon: Icon(Icons.person,
                color: active == 3 ? Color(0xFF5986E2) : Color(0xFF828282)),
            label: ''),
      ]);
}

