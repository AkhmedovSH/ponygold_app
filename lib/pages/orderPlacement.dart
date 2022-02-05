import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:PonyGold/globals.dart' as globals;
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderPlacement extends StatefulWidget {
  OrderPlacement({Key? key}) : super(key: key);

  @override
  _OrderPlacementState createState() => _OrderPlacementState();
}

class _OrderPlacementState extends State<OrderPlacement> {
  final _formKey = GlobalKey<FormState>();
  dynamic plasticCard = false;
  dynamic payme = false;
  dynamic cash = true;
  dynamic ponyGold = false;
  dynamic totalAmount = 0;
  dynamic totalAmountAll = 0;
  dynamic basket = [];
  dynamic city = {};
  dynamic user = {};
  String address = '';
  var maskFormatter = new MaskTextInputFormatter(
      mask: '+### (##) ### ## ##', filter: {"#": RegExp(r'[0-9]')});
  bool error = true;
  dynamic initialPosition = LatLng(0, 0);

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  void _getCurrentLocation() async {
    geolocator.Position position =
        await geolocator.Geolocator.getCurrentPosition(
            desiredAccuracy: geolocator.LocationAccuracy.high);
    setState(() {
      initialPosition = LatLng(position.latitude, position.longitude);
    });

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) {
    //     return PlacePicker(
    //       apiKey: 'AIzaSyC03ntzp6mTIIl_m0sLBSBaH9OEhcITh2A',
    //       initialPosition: initialPosition,
    //       useCurrentLocation: true,
    //       selectInitialPosition: true,
    //       //usePlaceDetailSearch: true,
    //       onPlacePicked: (result) {
    //         print(result);
    //         Navigator.of(context).pop();
    //         setState(() {});
    //       },
    //     );
    //   }),
    // );
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
          'city_id': city['id'],
          "delivery_price": city['delivery_price'],
          'payment_type': (cash
                  ? 0
                  : plasticCard
                      ? 1
                      : payme
                          ? 2
                          : 0)
              .toString()
        },
        context);
    prefs.remove('basket');
    await globals.checkLength(3);
    setState(() {});
    Navigator.pushNamedAndRemoveUntil(context, '/orders', (route) => false);
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
    setState(() {
      city = jsonDecode(prefs.getString('city').toString());
      user = jsonDecode(prefs.getString('user').toString());
      totalAmountAll =
          ((int.parse(city['delivery_price']) + totalAmount).toString());
    });
    print(user['id']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Корзина'),
        centerTitle: true,
        backgroundColor: globals.blue,
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
                  child: Text(
                      'Товары: ${globals.formatMoney(totalAmount.toString())} сум.'),
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
                  child: Text(
                      'Доставка: ${globals.formatMoney(city['delivery_price'].toString())}сум.'),
                )
                // Icon(Icons.crop_square),
              ],
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            address = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Обязательное поле';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0xFFECECEC), width: 1.0),
                            ),
                            contentPadding: EdgeInsets.all(15.0),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 2),
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
                            color: globals.blue,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            _getCurrentLocation();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                            ),
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                            child: Text(
                              'Добавить геолокацию',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: globals.blue,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: globals.blue,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 15),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Обязательное поле';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0xFFECECEC), width: 1.0),
                            ),
                            contentPadding: EdgeInsets.all(20.0),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 2),
                                borderRadius: BorderRadius.circular(5.0)),
                            hintText: 'Контактное лицо',
                            hintStyle: TextStyle(color: Colors.black),
                            fillColor: Colors.white,
                            filled: true),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: TextFormField(
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(19),
                          maskFormatter
                        ],
                        scrollPadding: EdgeInsets.only(bottom: 50),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Обязательное поле';
                          }
                          if (value.length < 9) {
                            return 'Минимум 9 символов';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0xFFECECEC), width: 1.0),
                            ),
                            contentPadding: EdgeInsets.all(20.0),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 2),
                                borderRadius: BorderRadius.circular(5.0)),
                            hintText: 'Номер телефона',
                            hintStyle: TextStyle(color: Colors.black),
                            fillColor: Colors.white,
                            filled: true),
                      ),
                    ),
                  ],
                )),
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
              color: globals.blue,
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
                                    if (int.parse(totalAmountAll) <=
                                        int.parse(user['pony_golds'])) {
                                      ponyGold = value;
                                      cash = false;
                                      payme = false;
                                      plasticCard = false;
                                    } else {
                                      error = false;
                                    }
                                  });
                                },
                              )),
                        ),
                        error
                            ? Container(
                                child: Text(
                                  'Использовать пониголды: ${globals.formatMoney(totalAmountAll.toString())} PG',
                                  style: TextStyle(
                                      color: Color(0xFF313131), fontSize: 16),
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    // margin: EdgeInsets.only(bottom: 5, top: 5),
                                    child: Text(
                                      'Использовать пониголды: ${globals.formatMoney(totalAmountAll.toString())} PG',
                                      style: TextStyle(
                                          color: Color(0xFF313131),
                                          decoration:
                                              TextDecoration.lineThrough,
                                          fontSize: 16),
                                    ),
                                  ),
                                  Container(
                                    // margin: EdgeInsets.symmetric(vertical: 5),
                                    child: Text('Недостаточно PG',
                                        style: TextStyle(
                                            color: Color(0xFFEB6465),
                                            fontSize: 16)),
                                  ),
                                ],
                              )
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 40, bottom: 10),
                          child: Text(
                            'Ваш счет: ${globals.formatMoney(user['pony_golds'].toString())} PG',
                            style: TextStyle(
                                color: Color(0xFF747474), fontSize: 14),
                          ),
                        ),
                        !error
                            ? Container(
                                margin: EdgeInsets.only(left: 10, bottom: 10),
                                child: Text(
                                  'Как получить?',
                                  style: TextStyle(
                                      color: Color(0xFF00B4AA),
                                      fontSize: 14,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w700),
                                ),
                              )
                            : Container()
                      ],
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
                            basket[i]['name_' + globals.lang],
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
                'Итого к оплате: ${globals.formatMoney(totalAmountAll.toString())}сум',
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
          style: ElevatedButton.styleFrom(primary: globals.blue),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              createOrder();
            }
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
