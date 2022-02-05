import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Controller extends GetxController {
  dynamic basketLength = false;
  dynamic ordersLength = false;
  checkLength(check) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (check == 1 || check == 3) {
      dynamic basket = prefs.getStringList('basket');
      if (basket != null) {
        basketLength = (basket.length > 0).obs;
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
        ordersLength = (responseJson['data'].length > 0);
      }
    }
    update();
  }
}
