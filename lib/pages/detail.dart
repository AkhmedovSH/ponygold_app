import 'package:PonyGold/components/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:PonyGold/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Detail extends StatefulWidget {
  Detail({Key? key}) : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  dynamic basket = [];
  dynamic product = {};
  dynamic responseBody = {};
  bool loading = false;
  dynamic bottomBar = globals.bottomBar;
  CarouselController buttonCarouselController = CarouselController();
  int _current = 0;
  dynamic images = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
    });
    getProduct();
  }

  getProduct() async {
    final response = await http.get(Uri.parse('https://ponygold.uz/api/client/product/${Get.arguments}'));
    if (response.statusCode == 200) {
      final responseJson = await jsonDecode(response.body);
      responseJson['discount_price'] =
          int.parse(responseJson['price']) - (int.parse(responseJson['price']) * int.parse(responseJson['discount'])) / 100;
      responseJson['discount_price'] = responseJson['discount_price'].round();
      setState(() {
        images = responseJson['images'].split(';');
        responseBody = response.body;
        product = responseJson;
        loading = false;
      });
    }
  }

  inBasket(id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var body = responseBody;
    var responseJson = jsonDecode(responseBody);
    final prefsBasket = prefs.getStringList('basket');
    if (prefsBasket == null) {
      var basketDecode = jsonDecode(body);
      basketDecode['quantity'] = 1;
      body = jsonEncode(basketDecode);
      prefs.setStringList('basket', [body]);
    } else {
      setState(() {
        basket = prefsBasket;
      });
      bool found = false;
      // print(basket[0]['category']['main_id'] !=
      //     responseBody['category']['main_id']);
      if (basket.length > 0) {
        var basketDecode = jsonDecode(basket[0]);
        if (basketDecode['category']['main_id'] != product['category']['main_id']) {
          return Get.snackbar('????????????', '???????????????? ???????????? ??????????????',
              colorText: Color(0xFFFFFFFF),
              onTap: (_) => print('DADA'),
              duration: Duration(seconds: 2),
              animationDuration: Duration(milliseconds: 600),
              snackPosition: SnackPosition.TOP,
              backgroundColor: Color(0xFFEB6465));
        }
      }
      for (var i = 0; i < basket.length; i++) {
        var basketDecode = jsonDecode(basket[i]);
        if (basketDecode['id'] == responseJson['id']) {
          basketDecode['quantity'] += 1;
          setState(() {
            basket[i] = jsonEncode(basketDecode);
          });
          found = true;
        }
      }
      if (!found) {
        setState(() {
          basket?.add(responseBody);
        });
        for (var i = 0; i < basket.length; i++) {
          var basketDecode = jsonDecode(basket[i]);
          basketDecode['quantity'] = 1;
          setState(() {
            basket[i] = jsonEncode(basketDecode);
          });
        }
      }
      prefs.setStringList('basket', basket);
    }
    await globals.checkLength(1);
    setState(() {});
    Get.snackbar('??????????????', '?????????????? ???????????????? ?? ??????????????',
        colorText: Color(0xFFFFFFFF),
        onTap: (_) => print(_),
        duration: Duration(seconds: 2),
        animationDuration: Duration(milliseconds: 600),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Color(0xFF39B499));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: globals.blue,
        elevation: 0.0,
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Padding(padding: EdgeInsets.only(top: 120)),
                  // Container(
                  //   width: MediaQuery.of(context).size.width,
                  //   height: 300,
                  //   decoration: BoxDecoration(
                  //     image: DecorationImage(
                  //       fit: BoxFit.fill,
                  //       scale: 1,
                  //       image: NetworkImage(
                  //         'https://ponygold.uz/uploads/products/' +
                  //             product['image'],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  CarouselSlider(
                    carouselController: buttonCarouselController,
                    items: [
                      for (var i = 0; i < images.length; i++)
                        Container(
                          child: Image.network('${globals.urlProducts + images[i]}', width: double.infinity, fit: BoxFit.cover),
                        )
                    ],
                    options: new CarouselOptions(
                      height: 300,
                      enlargeCenterPage: true,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      viewportFraction: 0.8,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      },
                    ),
                  ),
                  // Container(
                  //     decoration: new BoxDecoration(
                  //       color: Colors.white,
                  //     ),
                  //     height: 300,
                  //     child: Center(
                  //       child: Image.network('https://ponygold.uz/uploads/products/' + product['image'],
                  //           // width: double.infinity,
                  //           fit: BoxFit.fill),
                  //     )),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    for (var i = 0; i < images.length; i++)
                      GestureDetector(
                        onTap: () {
                          buttonCarouselController.animateToPage(i);
                        },
                        child: Container(
                          width: 12.0,
                          height: 12.0,
                          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
                          decoration: BoxDecoration(shape: BoxShape.circle, color: _current == i ? globals.blue : Color(0xFFE1E1E1)),
                        ),
                      )
                  ]),
                  Container(
                    margin: EdgeInsets.only(top: 40),
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Text(
                      product['name_' + globals.lang],
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF313131), fontFamily: 'ProDisplay'),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(16, 5, 16, 0),
                    child: Text(
                      '????????????:' + ' ' + product['id'].toString(),
                      style: TextStyle(fontSize: 14, color: Color(0xFF9F9B9B)),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(16, 5, 16, 0),
                    child: Text(
                      product['brand']['name'],
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(16, 5, 16, 0),
                    child: Text(
                      globals.formatMoney(product['discount_price'].toString()).toString() + '??????.',
                      style: TextStyle(
                          fontSize: 18, color: globals.blue, fontWeight: FontWeight.bold, fontStyle: FontStyle.normal, fontFamily: 'ProDisplay'),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(16, 5, 16, 10),
                    child: Text(
                      globals.formatMoney(product['price']),
                      style: TextStyle(fontSize: 16, decoration: TextDecoration.lineThrough, color: Color(0xFF747474)),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 80),
                    padding: EdgeInsets.fromLTRB(16, 5, 16, 0),
                    child: Text(
                      product['description_uz'],
                      style: TextStyle(fontSize: 18, color: Color(0xFF747474), letterSpacing: 0.06),
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: loading
          ? Container()
          : Container(
              margin: EdgeInsets.only(left: 30),
              height: 48,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: globals.blue,
                ),
                onPressed: () {
                  inBasket(product['id']);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 8),
                      child: Text(
                        '???????????????? ?? ??????????????',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Icon(Icons.shopping_cart_outlined)
                  ],
                ),
              ),
            ),
      bottomNavigationBar: BottomBar(
        active: 0,
      ),
    );
  }
}
