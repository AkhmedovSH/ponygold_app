import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:PonyGold/globals.dart' as globals;
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrderPlacement extends StatefulWidget {
  OrderPlacement({Key? key}) : super(key: key);

  @override
  _OrderPlacementState createState() => _OrderPlacementState();
}

class _OrderPlacementState extends State<OrderPlacement> {
  dynamic plasticCard = false;
  dynamic payme = false;
  dynamic cash = true;
  dynamic ponyGold = false;
  dynamic totalAmount = 0;
  dynamic basket = [];
  String address = '';

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  void _getCurrentLocation() async {
    geolocator.Position position =
        await geolocator.Geolocator.getCurrentPosition(
            desiredAccuracy: geolocator.LocationAccuracy.high);
    Get.toNamed("/google-map",
        arguments: [position.latitude, position.longitude]);
  }

  void createOrder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic token = prefs.getString('access_token');
    List<String> products = [];
    for (var i = 0; i < basket.length; i++) {
      products.add(jsonEncode(basket[i]));
    }
    final response = await globals.post(
        '/api/client/order',
        <String, dynamic>{
          "products": basket,
          'address': address,
          'latitude': globals.latitude.toString(),
          'longitude': globals.longitude.toString(),
          'total_amount': totalAmount,
          'payment_type': (cash
                  ? 0
                  : plasticCard
                      ? 1
                      : payme
                          ? 2
                          : null)
              .toString()
        },
        context);
    print(response);
    if (response.statusCode == 200) {
      prefs.remove('basket');
      globals.checkLength(3);
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
  }

  getProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var stringList = prefs.getStringList('basket');
    for (var i = 0; i < stringList!.length; i++) {
      var decode = jsonDecode(stringList[i]);
      setState(() {
        totalAmount += int.parse(decode['price']);
        basket.add(decode);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Корзина'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(15, 20, 15, 20),
              child: Text(
                'Внимание! После оформления заказ отмене не подлежит!',
                style: TextStyle(
                    color: Color(0xFFEB6465), fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 17, right: 10, bottom: 15),
                  child: Image.asset('images/box.png'),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 15),
                  child: Text('Товары: $totalAmount сум.'),
                )
                // Icon(Icons.crop_square),
              ],
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 17, right: 10, bottom: 15),
                  child: Image.asset('images/car.png'),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 15),
                  child: Text('Доставка: 250 000 000сум.'),
                )
                // Icon(Icons.crop_square),
              ],
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    address = value;
                  });
                },
                decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color(0xFFECECEC), width: 1.0),
                    ),
                    contentPadding: EdgeInsets.all(15.0),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2),
                        borderRadius: BorderRadius.circular(5.0)),
                    hintText: 'Район, улица, дом, квартира, ориентир',
                    hintStyle: TextStyle(color: Colors.black),
                    fillColor: Colors.white,
                    filled: true),
              ),
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 0, 15),
                  child: Icon(
                    Icons.location_on,
                    color: Color(0xFF5986E2),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _getCurrentLocation();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: Text(
                      'Добавить геолокацию',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF5986E2),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFF5986E2),
                    size: 16,
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 15),
              child: TextField(
                decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color(0xFFECECEC), width: 1.0),
                    ),
                    contentPadding: EdgeInsets.all(20.0),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2),
                        borderRadius: BorderRadius.circular(5.0)),
                    hintText: 'Контактное лицо',
                    hintStyle: TextStyle(color: Colors.black),
                    fillColor: Colors.white,
                    filled: true),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: TextField(
                decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color(0xFFECECEC), width: 1.0),
                    ),
                    contentPadding: EdgeInsets.all(20.0),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2),
                        borderRadius: BorderRadius.circular(5.0)),
                    hintText: 'Номер телефона',
                    hintStyle: TextStyle(color: Colors.black),
                    fillColor: Colors.white,
                    filled: true),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Text(
                'Способ оплаты',
                style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF313131),
                    fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              children: [
                Transform.scale(
                  scale: 1.2,
                  child: Theme(
                      data: ThemeData(
                        primarySwatch: Colors.blue,
                        unselectedWidgetColor: Color(0xFFBDBDBD), // Your color
                      ),
                      child: Checkbox(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        value: cash,
                        onChanged: (value) {
                          setState(() {
                            cash = value;
                            payme = false;
                            plasticCard = false;
                            ponyGold = false;
                          });
                        },
                      )),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      cash = !cash;
                      payme = false;
                      plasticCard = false;
                      ponyGold = false;
                    });
                  },
                  child: Text('Наличными курьеру',
                      style: TextStyle(fontSize: 18, color: Color(0xFF313131))),
                )
              ],
            ),
            Row(
              children: [
                Transform.scale(
                  scale: 1.2,
                  child: Theme(
                      data: ThemeData(
                        primarySwatch: Colors.blue,
                        unselectedWidgetColor: Color(0xFFBDBDBD), // Your color
                      ),
                      child: Checkbox(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        value: plasticCard,
                        onChanged: (value) {
                          setState(() {
                            cash = false;
                            payme = false;
                            plasticCard = value;
                            ponyGold = false;
                          });
                        },
                      )),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      cash = false;
                      payme = false;
                      plasticCard = !plasticCard;
                      ponyGold = false;
                    });
                  },
                  child: Text('Пластиковой картой курьеру',
                      style: TextStyle(fontSize: 18, color: Color(0xFF313131))),
                )
              ],
            ),
            Row(
              children: [
                Transform.scale(
                  scale: 1.2,
                  child: Theme(
                      data: ThemeData(
                        primarySwatch: Colors.blue,
                        unselectedWidgetColor: Color(0xFFBDBDBD), // Your color
                      ),
                      child: Checkbox(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        value: payme,
                        onChanged: (value) {
                          setState(() {
                            cash = false;
                            payme = value;
                            plasticCard = false;
                            ponyGold = false;
                          });
                        },
                      )),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      cash = false;
                      payme = !payme;
                      plasticCard = false;
                      ponyGold = false;
                    });
                  },
                  child: Text('Payme',
                      style: TextStyle(fontSize: 18, color: Color(0xFF313131))),
                ),
              ],
            ),
            DottedBorder(
              dashPattern: [5, 5, 5, 5],
              color: Color(0xFF5986E2),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Transform.scale(
                          scale: 1.2,
                          child: Theme(
                              data: ThemeData(
                                primarySwatch: Colors.blue,
                                unselectedWidgetColor:
                                    Color(0xFFBDBDBD), // Your color
                              ),
                              child: Checkbox(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                value: ponyGold,
                                onChanged: (value) {
                                  setState(() {
                                    cash = false;
                                    payme = false;
                                    ponyGold = value;
                                    plasticCard = false;
                                  });
                                },
                              )),
                        ),
                        Container(
                          child: Text(
                            'Использовать пониголды: 3 000 000 PG',
                            style: TextStyle(
                                color: Color(0xFF313131), fontSize: 16),
                          ),
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 40, bottom: 10),
                      child: Text(
                        'Ваш счет: 3 000 000 PG',
                        style:
                            TextStyle(color: Color(0xFF747474), fontSize: 14),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15, bottom: 15, top: 5),
              child: Text(
                'Состав заказа',
                style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF313131),
                    fontWeight: FontWeight.bold),
              ),
            ),
            Column(
              children: [
                for (var i = 0; i < basket.length; i++)
                  Stack(
                    children: [
                      Container(
                        child: Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(left: 15, bottom: 15),
                          child: Text(
                            basket[i]['name_uz'],
                            style: TextStyle(
                                color: Color(0xFF313131),
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            margin: EdgeInsets.only(right: 15),
                            child: Text(
                              'x' + basket[i]['quantity'].toString(),
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(
                                  0xFF313131,
                                ),
                              ),
                            ),
                          ))
                    ],
                  )
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 20, left: 15, bottom: 70),
              child: Text(
                'Итого к оплате: 123 444 444сум',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(left: 30, top: 20),
        height: 48,
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: Color(0xFF5986E2)),
          onPressed: () {
            createOrder();
          },
          child: Container(
            margin: EdgeInsets.only(right: 8),
            child: Text(
              'Продолжить',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
