import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:PonyGold/globals.dart' as globals;

class Search extends StatefulWidget {
  Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  var _controller = TextEditingController();
  int searchLength = 0;
  dynamic products = [];
  bool loading = false;
  Timer? _debounce;

  onSearch() async {
    if (_controller.text.length >= 3) {
      _debounce = Timer(const Duration(milliseconds: 500), () async {
        setState(() {
          loading = true;
        });
        final response = await http.get(Uri.parse(
            'https://ponygold.uz/api/client/search-products?name=${_controller.text}'));
        final responseJson = jsonDecode(response.body);
        setState(() {
          products = responseJson;
          loading = false;
        });
      });
    } else {
      setState(() {
        products = [];
      });
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Color(0xFF5986E2), //change your color here
        ),
        title: Text(
          'Pony Gold',
          style: TextStyle(
            color: Color(0xFF5986E2),
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 15),
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              color: Color(0xFFFBFBFB),
              child: TextField(
                autofocus: true,
                controller: _controller,
                onChanged: (value) {
                  onSearch();
                  setState(() {
                    searchLength = value.length;
                  });
                },
                decoration: InputDecoration(
                    prefixIcon: IconButton(
                      onPressed: () {
                        onSearch();
                      },
                      icon: Icon(
                        Icons.search,
                        color: Colors.blue,
                      ),
                    ),
                    suffixIcon: searchLength > 0
                        ? IconButton(
                            onPressed: () {
                              _controller.clear();
                              setState(() {
                                searchLength = 0;
                                products = [];
                              });
                            },
                            icon: Icon(
                              Icons.highlight_remove,
                              color: Colors.red,
                            ))
                        : null,
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    // focusedBorder: OutlineInputBorder(
                    //     borderSide: BorderSide(color: Color(0xFF5986E2))),
                    hintText: 'Поиск',
                    fillColor: Colors.white,
                    filled: true),
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
            loading
                ? Center(
                    child: Container(
                    margin: EdgeInsets.only(top: 20),
                    child: CircularProgressIndicator(),
                  ))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      for (var i = 0; i < products.length; i++)
                        GestureDetector(
                            onTap: () {
                              Get.toNamed('/detail',
                                  arguments: products[i]['id']);
                            },
                            child: Card(
                              margin: EdgeInsets.only(bottom: 15),
                              elevation: 5,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 80,
                                        // margin: EdgeInsets.only(
                                        //     left: 15, bottom: 15, top: 15),
                                        child: Image.network(
                                          'https://ponygold.uz/uploads/products/' +
                                              products[i]['image'],
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(),
                                            child: Text(
                                              products[i]['name_uz'],
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Color(0xFF747474)),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 20, bottom: 15),
                                            child: Text(
                                              products[i]['brand']['name'],
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(right: 15, bottom: 15),
                                    child: Text(
                                      globals.formatMoney(
                                              products[i]['price']) +
                                          ' сум.',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
