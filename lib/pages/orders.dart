import 'package:PonyGold/components/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_moment/simple_moment.dart';
import 'package:get/get.dart';
import 'package:PonyGold/globals.dart' as globals;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Orders extends StatefulWidget {
  Orders({Key? key}) : super(key: key);

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  dynamic orders = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
    });
    getOrders();
  }

  getOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
      var responseJson = jsonDecode(response.body);
      for (var i = 0; i < responseJson['data'].length; i++) {
        if (responseJson['data'][i]['status'] == '1') {
          responseJson['data'][i]['status_text'] = 'Обрабатывается';
          responseJson['data'][i]['status_color'] = 0xFFF3B231;
        }
        if (responseJson['data'][i]['status'] == '2') {
          responseJson['data'][i]['status_text'] = 'Обработано';
          responseJson['data'][i]['status_color'] = 0xFFB439A7;
        }
        if (responseJson['data'][i]['status'] == '3') {
          responseJson['data'][i]['status_text'] = 'В пути';
          responseJson['data'][i]['status_color'] = globals.blue;
        }
        if (responseJson['data'][i]['status'] == '4') {
          responseJson['data'][i]['status_text'] = 'Доставлено';
          responseJson['data'][i]['status_color'] = 0xFF39B499;
        }
      }
      setState(() {
        orders = responseJson['data'];
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Мои заказы'),
        centerTitle: true,
        backgroundColor: globals.blue,
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(16),
                child: orders.length > 0
                    ? Column(
                        children: [
                          for (var i = 0; i < orders.length; i++)
                            GestureDetector(
                              onTap: () {
                                Get.toNamed("/detail-order",
                                    arguments: orders[i]);
                              },
                              child: Container(
                                  height: 120,
                                  width: double.infinity,
                                  margin: EdgeInsets.only(bottom: 15),
                                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                      border:
                                          Border.all(color: Color(0xFFECECEC))),
                                  child: Stack(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(bottom: 5),
                                            child: Text(
                                              'Заказ №${orders[i]['id']}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              globals.formatDate(
                                                  orders[i]['created_at']),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xFF747474)),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Positioned(
                                          right: 8,
                                          child: Container(
                                              child: Icon(
                                            Icons.arrow_forward_ios,
                                            size: 18,
                                            color: globals.blue,
                                          ))),
                                      Positioned(
                                          // left: 6,
                                          bottom: 4,
                                          child: Container(
                                              child: Text(
                                            globals.formatMoney(orders[i]
                                                        ['total_amount']
                                                    .toString()) +
                                                ' сум',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ))),
                                      Positioned(
                                          right: 5,
                                          bottom: 4,
                                          child: Row(
                                            children: [
                                              Container(
                                                margin:
                                                    EdgeInsets.only(right: 5),
                                                width: 5,
                                                height: 5,
                                                decoration: BoxDecoration(
                                                  color: Color(orders[i]
                                                      ['status_color']),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5.0)),
                                                ),
                                              ),
                                              Container(
                                                  child: Text(
                                                orders[i]['status_text']
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Color(orders[i]
                                                        ['status_color']),
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ))
                                            ],
                                          ))
                                    ],
                                  )),
                            )
                        ],
                      )
                    : Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Text(
                            'У вас нет активных заказов',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
              ),
            ),
      bottomNavigationBar: BottomBar(
        active: 2,
      ),
    );
  }
}
