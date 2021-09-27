import 'package:flutter/material.dart';
import 'package:PonyGold/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
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

  @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
    });
    getProduct();
  }

  getProduct() async {
    final response = await http.get(
        Uri.parse('https://ponygold.uz/api/client/product/${Get.arguments}'));
    if (response.statusCode == 200) {
      final responseJson = await jsonDecode(response.body);
      responseJson['discount_price'] = int.parse(responseJson['price']) -
          (int.parse(responseJson['price']) *
                  int.parse(responseJson['discount'])) /
              100;
      setState(() {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Color(0xFF5986E2),
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
                  Padding(padding: EdgeInsets.only(top: 80)),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                            'https://ponygold.uz/uploads/products/' +
                                product['image']),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 40),
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Text(
                      product['name'],
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF313131),
                          fontFamily: 'ProDisplay'),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(16, 5, 16, 0),
                    child: Text(
                      'Арткул:' + ' ' + product['vendor_code'].toString(),
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
                      product['discount_price'].toString() + 'сум.',
                      style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF5986E2),
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                          fontFamily: 'ProDisplay'),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(16, 5, 16, 0),
                    child: Text(
                      product['price'],
                      style: TextStyle(
                          fontSize: 16,
                          decoration: TextDecoration.lineThrough,
                          color: Color(0xFF747474)),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 50),
                    padding: EdgeInsets.fromLTRB(16, 5, 16, 0),
                    child: Text(
                      product['description'],
                      style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF747474),
                          letterSpacing: 0.06),
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: Align(
        child: Container(
          margin: EdgeInsets.only(left: 30),
          height: 48,
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: loading ? Color(0xFF747474) : Color(0xFF5986E2),
            ),
            onPressed: () {
              loading ? null : inBasket(product['id']);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 8),
                  child: Text(
                    'Добавить в корзину',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Icon(Icons.shopping_cart_outlined)
              ],
            ),
          ),
        ),
        alignment: Alignment(1, 1.04),
      ),
      bottomNavigationBar: globals.bottomBar,
    );
  }
}
