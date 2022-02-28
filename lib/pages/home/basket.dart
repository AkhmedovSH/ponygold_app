import 'dart:convert';
import 'package:PonyGold/components/bottom_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:PonyGold/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class Basket extends StatefulWidget {
  Basket({Key? key}) : super(key: key);

  @override
  _BasketState createState() => _BasketState();
}

class _BasketState extends State<Basket> {
  dynamic basket = [];
  dynamic city = {};
  dynamic stringList = [];
  Widget bottomBar = globals.bottomBar;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getCities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('city') != null) {
      final cityString = jsonDecode(prefs.getString('city') as String);
      if (cityString != null) {
        setState(() {
          city = cityString;
        });
      }
    } else {
      setState(() {
        city = null;
      });
    }
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final basketString = prefs.getStringList('basket');
    if (prefs.getStringList('basket') != null) {
      if (basketString!.length > 0) {
        for (var i = 0; i < basketString.length; i++) {
          setState(() {
            basket.add(jsonDecode(basketString[i]));
            stringList.add((basketString[i]));
          });
        }
      }
    }
    getCities();
  }

  setBasket() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> _cardInfo = [];
    for (int i = 0; i < stringList.length; i++) {
      _cardInfo.add(stringList[i] as String);
    }
    prefs.setStringList('basket', _cardInfo);
  }

  delete(i) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      stringList.removeAt(i);
      basket.removeAt(i);
    });
    List<String> _cardInfo = [];
    for (int i = 0; i < stringList.length; i++) {
      _cardInfo.add(stringList[i] as String);
    }
    prefs.setStringList('basket', _cardInfo);
    globals.checkLength(1);
    setState(() {
      bottomBar = globals.bottomBar;
    });
  }

  increment(i) async {
    var obj = jsonDecode(stringList[i]);
    obj['quantity'] += 1;
    setState(() {
      basket[i]['quantity'] += 1;
      stringList[i] = jsonEncode(obj);
    });
    setBasket();
  }

  decrement(i) async {
    var obj = jsonDecode(stringList[i]);
    obj['quantity'] -= 1;
    setState(() {
      basket[i]['quantity'] -= 1;
      stringList[i] = jsonEncode(obj);
    });
    if (basket[i]['quantity'] == 0) {
      delete(i);
    } else {
      setBasket();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.basket,
        ),
        centerTitle: true,
        backgroundColor: globals.blue,
      ),
      body: basket.length > 0
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                    child: Text(
                      AppLocalizations.of(context)!.specify_city_or_region_to_find_out_the_availability_of_goods_in_your_region,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFFEB6465), fontWeight: FontWeight.bold),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final result = await Navigator.of(context).pushNamed('/cities');
                      print(result);
                      getCities();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                          child: Icon(
                            Icons.location_on,
                            color: globals.blue,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                          child: city != null
                              ? Container(
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  child: Text(
                                    'Доставка в ${city['name']}',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 20, decoration: TextDecoration.underline),
                                  ),
                                )
                              : Text(
                                  'Выберите место доставки',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20, decoration: TextDecoration.underline),
                                ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        for (var i = 0; i < basket.length; i++)
                          Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                                width: 350,
                                height: 170,
                                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    top: BorderSide(width: 1.0, color: Color(0xFFECECEC)),
                                    left: BorderSide(width: 1.0, color: Color(0xFFECECEC)),
                                    right: BorderSide(width: 1.0, color: Color(0xFFECECEC)),
                                    bottom: BorderSide(width: 1.0, color: Color(0xFFECECEC)),
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(right: 15),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                          ),
                                          child: Image.network(
                                            'https://ponygold.uz/uploads/products/' + basket[i]['image'],
                                            height: 80,
                                            width: 80,
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Text(
                                                basket[i]['name_' + globals.lang],
                                                style: basket[i]['available'] == '1'
                                                    ? TextStyle(fontWeight: FontWeight.w600, fontSize: 16)
                                                    : TextStyle(fontWeight: FontWeight.w600, fontSize: 16, decoration: TextDecoration.lineThrough),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [],
                                    )
                                  ],
                                ),
                              ),
                              Positioned(
                                  left: 10,
                                  bottom: 30,
                                  child: Container(
                                    child: IconButton(
                                      // highlightColor: Colors.transparent,
                                      // splashColor: Colors.transparent,
                                      icon: Icon(
                                        Icons.close_outlined,
                                        size: 40,
                                      ),
                                      onPressed: () {
                                        delete(i);
                                      },
                                    ),
                                  )),
                              Positioned(
                                  right: 10,
                                  bottom: 30,
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          decrement(i);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Color(0xFFECECEC)),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(7.0),
                                              topRight: Radius.zero,
                                              bottomLeft: Radius.circular(7.0),
                                              bottomRight: Radius.zero,
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          width: 50,
                                          height: 50,
                                          child: Text(
                                            '-',
                                            style: TextStyle(fontSize: 35, color: Color(0xFF747474)),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(color: Color(0xFFF4F7FA), border: Border.all(color: Color(0xFFECECEC))),
                                        width: 50,
                                        height: 50,
                                        child: Text(basket[i]['quantity'].toString()),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          increment(i);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Color(0xFFECECEC)),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.zero,
                                              topRight: Radius.circular(7.0),
                                              bottomLeft: Radius.zero,
                                              bottomRight: Radius.circular(7.0),
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          width: 50,
                                          height: 50,
                                          child: Text(
                                            '+',
                                            style: TextStyle(fontSize: 35, color: Color(0xFF747474)),
                                          ),
                                        ),
                                      )
                                    ],
                                  ))
                            ],
                          ),
                        Padding(padding: EdgeInsets.only(top: 60))
                      ],
                    ),
                  )
                ],
              ),
            )
          : Center(
              child: Container(
                child: Text('НЕТ ПРОДУКТОВ'),
              ),
            ),
      floatingActionButton: basket.length > 0
          ? Container(
              margin: EdgeInsets.only(left: 30, top: 20),
              height: 48,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: globals.blue),
                onPressed: () {
                  if (city != null) {
                    Get.toNamed('/order-placement');
                  } else {
                    globals.showDangerToast('Выберите место для доставки');
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
            )
          : Container(),
      bottomNavigationBar: BottomBar(
        active: 1,
      ),
    );
  }
}
