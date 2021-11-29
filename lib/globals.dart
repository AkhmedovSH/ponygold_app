library PonyGold.globals;

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_moment/simple_moment.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';

String otp = '';
String phone = '';
String lang = 'ru';
bool loading = false;
double latitude = 0.0;
double longitude = 0.0;
int id = 1;

Color white = Color(0xFFFFFFFF);
Color black = Color(0xFF313131);
Color blue = Color(0xFF00B4AA);
Color lightGrey = Color(0xFF313131);
Color light = Color(0xFFECECEC);
Color red = Color(0xFFEB6465);
Color yellow = Color(0xFF313131);
Color green = Color(0xFF39B499);
Color grey = Color(0xFF747474);
Color grey3 = Color(0xFF828282);
Color disabled = Color(0xFF828282);
Color purple = Color(0xFFB439A7);

formatMoney(price) {
  var value = price;
  value = value.replaceAll(RegExp(r'\D'), '');
  value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ' ');
  return value;
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
  if (index != active) {
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
          icon: Icon(Icons.home, color: active == 0 ? blue : Color(0xFF828282)),
          label: '',
        ),
        BottomNavigationBarItem(
            icon: Stack(children: [
              Icon(Icons.shopping_cart_outlined,
                  color: active == 1 ? blue : Color(0xFF828282)),
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
                    color: active == 2 ? blue : Color(0xFF828282)),
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
                color: active == 3 ? blue : Color(0xFF828282)),
            label: ''),
      ]);
}

Widget bottomBar = BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    showSelectedLabels: false,
    currentIndex: active,
    showUnselectedLabels: false,
    // selectedItemColor: blue,
    // unselectedItemColor: Colors.black,
    onTap: onItemTab,
    items: [
      BottomNavigationBarItem(
        icon: Icon(Icons.home, color: active == 0 ? blue : Color(0xFF828282)),
        label: '',
      ),
      BottomNavigationBarItem(
          icon: Stack(children: [
            Icon(Icons.shopping_cart_outlined,
                color: active == 1 ? blue : Color(0xFF828282)),
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
                  color: active == 2 ? blue : Color(0xFF828282)),
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
          icon:
              Icon(Icons.person, color: active == 3 ? blue : Color(0xFF828282)),
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
    if (basket != null) {
      basketlength = basket.length > 0;
    }
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
    if (response.statusCode == 200) {
      final responseJson = await jsonDecode(response.body);
      ordersLength = responseJson['data'].length > 0;
    }
  }
  bottomBar = BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      currentIndex: active,
      showUnselectedLabels: false,
      onTap: onItemTab,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, color: active == 0 ? blue : Color(0xFF828282)),
          label: '',
        ),
        BottomNavigationBarItem(
            icon: Stack(children: [
              Icon(Icons.shopping_cart_outlined,
                  color: active == 1 ? blue : Color(0xFF828282)),
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
                    color: active == 2 ? blue : Color(0xFF828282)),
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
                color: active == 3 ? blue : Color(0xFF828282)),
            label: ''),
      ]);
  return bottomBar;
}

String baseUrl = 'https://ponygold.uz';

get(url, context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  dynamic token = prefs.getString('access_token');
  final response = await http.get(
    Uri.parse(baseUrl + url),
    headers: {
      // HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    },
  );
  // print(response);
  statusCheck(response);
  final responseJson = jsonDecode(response.body);
  return responseJson;
}

post(url, payload, context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  dynamic token = prefs.getString('access_token');
  final response = await http.post(
    Uri.parse(baseUrl + url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    },
    body: jsonEncode(payload),
  );
  final responseJson = jsonDecode(response.body);
  await statusCheck(response);
  await statusCheck(response);
  if (response.statusCode == 400) {
    // showToast(context, 'Произошла ошибка');
    Get.snackbar('Ошибка', '${responseJson['error']}',
        colorText: Color(0xFFFFFFFF),
        onTap: (_) => print('DADA'),
        duration: Duration(seconds: 2),
        animationDuration: Duration(milliseconds: 600),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Color(0xFFEB6465));
    return response;
  }
  if (response.statusCode == 200) {
    // showToast(context, 'Успешно');
    return jsonDecode(response.body);
  }
  if (response.statusCode == 401) {
    final user = jsonDecode(prefs.getString('user').toString());
    final password = jsonDecode(prefs.getString('password').toString());
    final login = await http.post(
      Uri.parse('https://ponygold.uz/api/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'phone': user['phone'],
        'password': password.toString()
      }),
    );
    if (login.statusCode == 200) {
      final responseJson = jsonDecode(login.body);
      prefs.setString('access_token', responseJson['access_token']);
      prefs.setString('user', jsonEncode(responseJson['user']));
      prefs.setString('password', password.toString());
      final response = await http.post(
        Uri.parse(baseUrl + url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: jsonEncode(payload),
      );
    }
  }
}

statusCheck(response) async {
  if (response.statusCode == 401) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  }
  if (response.statusCode == 200) {
    return 200;
  }
  if (response.statusCode == 400 ||
      response.statusCode == 402 ||
      response.statusCode == 405) {
    Get.snackbar('Ошибка', '${response.body}',
        colorText: Color(0xFFFFFFFF),
        onTap: (_) => print('DADA'),
        duration: Duration(seconds: 2),
        animationDuration: Duration(milliseconds: 600),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Color(0xFFEB6465));
  }

  return;
}

showDangerToast(text) {
  Get.snackbar('Ошибка', '$text',
      colorText: Color(0xFFFFFFFF),
      onTap: (_) => print('DADA'),
      duration: Duration(seconds: 2),
      animationDuration: Duration(milliseconds: 600),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Color(0xFFEB6465));
}

showSuccessToast(text) {
  Get.snackbar('Успешно', '$text',
      colorText: Color(0xFFFFFFFF),
      onTap: (_) => print(_),
      duration: Duration(seconds: 2),
      animationDuration: Duration(milliseconds: 600),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Color(0xFF39B499));
}
