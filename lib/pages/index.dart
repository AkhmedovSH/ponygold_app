import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:PonyGold/globals.dart' as globals;
import 'package:PonyGold/components/bottom_bar.dart';

class Index extends StatefulWidget {
  Index({Key? key}) : super(key: key);

  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  int searchLength = 0;
  List<dynamic> categories = [];
  List<dynamic> products = [];
  dynamic searchProducts = [];
  Map<String, dynamic> map1 = {'zero': 0, 'one': 1, 'two': 2};
  bool loading = false;
  bool pageLoading = false;
  int _current = 0;
  Widget bottomBar = globals.bottomBar;
  CarouselController buttonCarouselController = CarouselController();
  int page = 1;
  var scrollController = ScrollController();
  var _controller = TextEditingController();

  @override
  void initState() {
    globals.active = 0;
    scrollController.addListener(scrollListener);
    setState(() {
      bottomBar = globals.bottomBar;
      loading = true;
    });
    super.initState();
    getProducts();
  }

  scrollListener() {
    // print(scrollController.position.maxScrollExtent);
    // print(!scrollController.position.outOfRange);

    if (scrollController.offset >=
            scrollController.position.maxScrollExtent - 2 &&
        !scrollController.position.outOfRange) {
      getNextProducts();
      // if (widget.usersProvider.hasNext) {
      //   widget.usersProvider.fetchNextUsers();
      // }
    }
  }

  getNextProducts() async {
    setState(() {
      pageLoading = true;
    });

    final response = await http.get(
        Uri.parse('https://ponygold.uz/api/client/products?page=${page + 1}'));
    final responseJson = jsonDecode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        pageLoading = false;
        products.addAll(responseJson['data']);
        if (responseJson['data'].length > 0) {
          page += 1;
        }
      });
    }
  }

  getProducts() async {
    final response =
        await http.get(Uri.parse('https://ponygold.uz/api/client/products'));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic responseCategories = categories;
    dynamic responseJsonCategories = {};
    if (prefs.getString('mainCategories') == null) {
      responseCategories = await http
          .get(Uri.parse('https://ponygold.uz/api/client/main-categories'));
      prefs.setString('mainCategories', responseCategories.body);
      responseJsonCategories = jsonDecode(responseCategories.body);
    } else {
      responseCategories = prefs.getString('mainCategories');
      responseJsonCategories = jsonDecode(responseCategories);
    }
    // final responseCategories = await http
    //     .get(Uri.parse('https://ponygold.uz/api/client/main-categories'));

    if (response.statusCode == 200 || responseCategories.statusCode == 200) {
      final responseJson = await jsonDecode(response.body);
      for (var i = 0; i < responseJson['data'].length; i++) {
        responseJson['data'][i]['discount_price'] = 0;
        responseJson['data'][i]['discount_price'] =
            (int.parse(responseJson['data'][i]['price']) -
                    (int.parse(responseJson['data'][i]['price']) *
                        int.parse(responseJson['data'][i]['discount']) /
                        100))
                .round();
      }
      if (!mounted) return;
      setState(() {
        categories = responseJsonCategories;
        products = responseJson['data'];
        loading = false;
      });
    }
  }

  onSearch() async {
    if (_controller.text.length >= 3) {
      globals.loading = false;
      final response = await http.get(Uri.parse(
          'https://ponygold.uz/api/client/search-products?name=${_controller.text}'));
      final responseJson = jsonDecode(response.body);
      globals.loading = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: globals.blue,
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Get.toNamed('/search');
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => Search()),
                // );
              })
        ],
        title: Text('Pony Gold'),
        centerTitle: true,
        elevation: 0,
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(
                color: globals.blue,
              ),
            )
          : SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 20, 0, 20),
                    child: Text(
                      AppLocalizations.of(context)!.categories,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (var i = 0; i < categories.length; i++)
                          GestureDetector(
                            onTap: () {
                              Get.toNamed("/categories",
                                  arguments: categories[i]['id']);
                            },
                            child: Container(
                                width: 144,
                                margin: EdgeInsets.symmetric(horizontal: 8.0),
                                decoration: BoxDecoration(
                                  color: Color(0xFFF4F7FA),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  children: [
                                    Padding(padding: EdgeInsets.only(top: 10)),
                                    Image.network(
                                      'https://ponygold.uz/uploads/categories/' +
                                          categories[i]['image'],
                                      height: 80,
                                      width: double.infinity,
                                    ),
                                    Padding(padding: EdgeInsets.only(top: 10)),
                                    Text(
                                      categories[i]['name_ru'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700),
                                    )
                                  ],
                                )),
                          )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 20, 0, 20),
                    child: Text(
                      AppLocalizations.of(context)!.recommended,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    child: CarouselSlider(
                      carouselController: buttonCarouselController,
                      items: [
                        for (var i = 0; i < categories.length; i++)
                          Container(
                            child: Image.asset('images/banner.png',
                                width: double.infinity, fit: BoxFit.fill),
                          )
                      ],
                      options: new CarouselOptions(
                        height: 150.0,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        aspectRatio: 16 / 9,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enableInfiniteScroll: true,
                        autoPlayAnimationDuration: Duration(milliseconds: 3000),
                        viewportFraction: 0.8,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        },
                      ),
                    ),
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    for (var i = 0; i < categories.length; i++)
                      GestureDetector(
                        onTap: () {
                          buttonCarouselController.animateToPage(i);
                        },
                        child: Container(
                          width: 12.0,
                          height: 12.0,
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _current == i
                                  ? globals.blue
                                  : Color(0xFFE1E1E1)),
                        ),
                      )
                  ]),
                  loading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: globals.blue,
                          ),
                        )
                      : GridView.count(
                          childAspectRatio: 0.76,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          primary: false,
                          padding: const EdgeInsets.all(10),
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          crossAxisCount: 2,
                          children: [
                            for (int i = 0; i < products.length; i++)
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed('/detail',
                                      arguments: products[i]['id']);
                                },
                                child: Container(
                                  // height: double.infinity,
                                  // height:
                                  //     MediaQuery.of(context).size.height * 0.70,
                                  // width: width == 392.72727272727275
                                  //     ? 190
                                  //     : width == 411.42857142857144
                                  //         ? 200
                                  //         : 190,
                                  // margin: EdgeInsets.fromLTRB(
                                  //     0, 10, i % 2 == 0 ? 10 : 0, 10),
                                  padding: EdgeInsets.all(0),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                      top: BorderSide(
                                          width: 1.0, color: Color(0xFFECECEC)),
                                      left: BorderSide(
                                          width: 1.0, color: Color(0xFFECECEC)),
                                      right: BorderSide(
                                          width: 1.0, color: Color(0xFFECECEC)),
                                      bottom: BorderSide(
                                          width: 1.0, color: Color(0xFFECECEC)),
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Image.network(
                                                'https://ponygold.uz/uploads/products/' +
                                                    products[i]['image'],
                                                height: 140,
                                                width: double.infinity,
                                                fit: BoxFit.fill),
                                          ),
                                          int.parse(products[i]['discount']) !=
                                                  0
                                              ? Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft: Radius.zero,
                                                      topRight:
                                                          Radius.circular(5.0),
                                                      bottomLeft: Radius.zero,
                                                      bottomRight:
                                                          Radius.circular(5.0),
                                                    ),
                                                    border: Border.all(
                                                      width: 1,
                                                      color: Color(0xFFEB6465),
                                                      style: BorderStyle.solid,
                                                    ),
                                                    color: Color(0xFFEB6465),
                                                  ),
                                                  margin:
                                                      EdgeInsets.only(top: 10),
                                                  padding: EdgeInsets.fromLTRB(
                                                      5, 3, 5, 3),
                                                  child: Text(
                                                    '-' +
                                                        products[i]['discount']
                                                            .toString() +
                                                        '%',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ))
                                              : Container(),
                                        ],
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 8),
                                        margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                        child: Text(
                                          products[i]['name_uz'],
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontFamily: 'ProDisplay',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.12),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 8),
                                        margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                        child: Text(
                                          products[i]['brand']['name'],
                                          style: TextStyle(
                                              fontFamily: 'ProDisplay',
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              color: Color(0xFF747474),
                                              letterSpacing: 0.12),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 8),
                                        margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                        child: Text(
                                          globals.formatMoney(products[i]
                                                      ['discount_price']
                                                  .toString()) +
                                              'сум.',
                                          style: TextStyle(
                                              color: globals.blue,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      int.parse(products[i]['discount']) != 0
                                          ? Container(
                                              padding: EdgeInsets.only(left: 8),
                                              child: Text(
                                                globals
                                                    .formatMoney(
                                                        products[i]['price'])
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xFF747474),
                                                    decoration: TextDecoration
                                                        .lineThrough),
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                              )
                          ],
                        ),
                  pageLoading
                      ? Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 20, bottom: 20),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
      bottomNavigationBar: BottomBar(active: 0),
    );
  }
}

// class Search extends SearchDelegate<String> {
//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [IconButton(onPressed: () {}, icon: Icon(Icons.clear))];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//         onPressed: () {},
//         icon: AnimatedIcon(
//             icon: AnimatedIcons.menu_arrow, progress: transitionAnimation));
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     // TODO: implement buildResults
//     throw UnimplementedError();
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     // TODO: implement buildSuggestions
//     throw UnimplementedError();
//   }
// }
