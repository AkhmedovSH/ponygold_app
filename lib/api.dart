import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:PonyGold/globals.dart' as globals;

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
  return response;
}

post(url, payload, context) async {
  final response = await http.post(
    Uri.parse(baseUrl + url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(payload),
  );
  if (response.statusCode == 400) {
    globals.showToast(context, 'Произошла ошибка');
    return;
  }
  if (response.statusCode == 200) {
    globals.showToast(context, 'Успешно');
    return jsonDecode(response.body);
  }
}