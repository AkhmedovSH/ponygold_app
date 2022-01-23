import 'package:PonyGold/components/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:PonyGold/globals.dart' as globals;
import 'package:get/get.dart';
import 'dart:math' as math;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Categories extends StatefulWidget {
  Categories({Key? key}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  dynamic products = [];
  dynamic categories = {};
  dynamic id = 0;
  dynamic priceFrom = 0;
  dynamic priceTo = 10000000;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      id = Get.arguments;
    });
    getCategories();
  }

  getCategories() async {
    setState(() {
      loading = false;
    });
    final response = await http
        .get(Uri.parse('https://ponygold.uz/api/client/category-childs/$id'));
    final responseJson = jsonDecode(response.body);
    setState(() {
      categories = responseJson;
    });
    if (responseJson['parent_id'] == '0') {
      getMainProducts();
    } else {
      getProducts();
    }
  }

  getMainProducts() async {
    final response = await http.get(Uri.parse(
        'https://ponygold.uz/api/client/category-childs-products/$id?priceFrom=$priceFrom&priceTo=$priceTo'));
    final responseJson = jsonDecode(response.body);
    for (var i = 0; i < responseJson['data'].length; i++) {
      responseJson['data'][i]['discount_price'] =
          int.parse(responseJson['data'][i]['price']) -
              (int.parse(responseJson['data'][i]['price']) *
                  double.parse(responseJson['data'][i]['discount']) /
                  100);
      responseJson['data'][i]['discount_price'] =
          responseJson['data'][i]['discount_price'].round();
    }
    setState(() {
      products = responseJson['data'];
      loading = true;
    });
  }

  getProducts() async {
    final response = await http.get(Uri.parse(
        'https://ponygold.uz/api/client/category-products/$id?priceFrom=$priceFrom&priceTo=$priceTo'));
    final responseJson = jsonDecode(response.body);
    for (var i = 0; i < responseJson['data'].length; i++) {
      responseJson['data'][i]['discount_price'] =
          int.parse(responseJson['data'][i]['price']) -
              (int.parse(responseJson['data'][i]['price']) *
                  double.parse(responseJson['data'][i]['discount']) /
                  100);
      responseJson['discount_price'] = responseJson['discount_price'].round();
    }
    setState(() {
      products = responseJson['data'];
      loading = true;
    });
    // getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Категории'),
        centerTitle: true,
        backgroundColor: globals.blue,
      ),
      body: loading
          ? Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.all(20),
                      child: Text(
                        categories['name_' + globals.lang],
                        style:
                            TextStyle(color: Color(0xFF313131), fontSize: 20),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final result =
                            await Get.toNamed('/filter', arguments: id);
                        print(result);
                        if (result != null) {
                          setState(() {
                            id = result[0];
                            priceFrom = result[1];
                            priceTo = result[2];
                          });
                        }
                        getCategories();
                      },
                      child: Row(
                        children: [
                          Text(
                            'Фильтр',
                            style: TextStyle(
                                fontSize: 18, color: Color(0xFF747474)),
                          ),
                          Image.asset('images/filter.png'),
                          Padding(padding: EdgeInsets.only(right: 20))
                        ],
                      ),
                    )
                  ],
                ),
                GridView.count(
                  childAspectRatio: 0.64,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  padding: const EdgeInsets.all(10),
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                  crossAxisCount: 2,
                  children: [
                    for (int i = 0; i < products.length; i++)
                      GestureDetector(
                        onTap: () {
                          Get.toNamed('/detail', arguments: products[i]['id']);
                        },
                        child: new Container(
                          height: 260,
                          // padding: EdgeInsets.all(8),
                          // margin: EdgeInsets.fromLTRB(
                          //     0, 10, i % 2 == 0 ? 10 : 0, 10),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    child: Image.network(
                                      'https://ponygold.uz/uploads/products/' +
                                          products[i]['image'],
                                      height: 200,
                                    ),
                                  ),
                                  products[i]['discount'] != '0'
                                      ? Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.zero,
                                              topRight: Radius.circular(5.0),
                                              bottomLeft: Radius.zero,
                                              bottomRight: Radius.circular(5.0),
                                            ),
                                            border: Border.all(
                                              width: 1,
                                              color: Color(0xFFEB6465),
                                              style: BorderStyle.solid,
                                            ),
                                            color: Color(0xFFEB6465),
                                          ),
                                          margin: EdgeInsets.only(top: 10),
                                          padding:
                                              EdgeInsets.fromLTRB(5, 3, 5, 3),
                                          child: Text(
                                            '-' +
                                                products[i]['discount']
                                                    .toString() +
                                                '%',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ))
                                      : Container()
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 8),
                                margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                child: Text(
                                  products[i]['name_' + globals.lang],
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
                                  globals.formatMoney(products[i]
                                              ['discount_price']
                                          .toString()) +
                                      'сум.',
                                  style: TextStyle(
                                      color: globals.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 8),
                                child: Text(
                                  globals
                                      .formatMoney(products[i]['price'])
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF747474),
                                      decoration: TextDecoration.lineThrough),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                  ],
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(
                color: globals.blue,
              ),
            ),
      bottomNavigationBar: BottomBar(active: 0),
    );
  }
}

// class Filter extends StatefulWidget {
//   Filter({Key? key, this.id}) : super(key: key);

//   final dynamic id;

//   @override
//   _FilterState createState() => _FilterState();
// }

// class _FilterState extends State<Filter> {
//   dynamic categories = [];
//   String dropdownValue = 'One';
//   bool loading = true;
//   bool showCategories = false;
//   RangeValues _currentRangeValues = const RangeValues(0, 1000000);
//   var _priceFrom = TextEditingController(text: '0');
//   var _priceTo = TextEditingController(text: '1000000');

//   @override
//   void initState() {
//     super.initState();
//     setState(() {
//       loading = false;
//     });
//     getCategories();
//   }

//   getCategories() async {
//     final response = await http.get(Uri.parse(
//         'https://ponygold.uz/api/client/category-childs/${widget.id}'));
//     final responseJson = jsonDecode(response.body);
//     if (response.statusCode == 200) {
//       setState(() {
//         categories = responseJson;
//       });
//       for (var i = 0; i < responseJson['childs'].length; i++) {
//         dynamic childId = responseJson['childs'][i]['id'];
//         final response2 = await http.get(Uri.parse(
//             'https://ponygold.uz/api/client/category-childs/$childId'));
//         final responseJson2 = jsonDecode(response2.body);
//         if (response2.statusCode == 200) {
//           setState(() {
//             categories['childs'][i]['show'] = false;
//             categories['childs'][i]['childs'] = responseJson2['childs'];
//           });
//         }
//       }
//     }
//     setState(() {
//       loading = true;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(Icons.arrow_back),
//         ),
//         backgroundColor: globals.blue,
//       ),
//       body: loading
//           ? SingleChildScrollView(
//               child: Column(
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       margin: EdgeInsets.only(top: 20, left: 15, bottom: 10),
//                       child: Text(
//                         'Цена (сум)',
//                         style: TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         Flexible(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Container(
//                                 margin: EdgeInsets.only(left: 15),
//                                 child: Text(
//                                   'ОТ',
//                                   style: TextStyle(fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                               Container(
//                                   margin: EdgeInsets.only(left: 15, bottom: 5),
//                                   width: 180,
//                                   height: 30,
//                                   child: TextFormField(
//                                     keyboardType: TextInputType.number,
//                                     controller: _priceFrom,
//                                     decoration: InputDecoration(
//                                       border: OutlineInputBorder(),
//                                     ),
//                                     onChanged: (value) {
//                                       if (int.parse(value) <
//                                           _currentRangeValues.end.round()) {
//                                         setState(() {
//                                           _currentRangeValues = RangeValues(
//                                               double.parse(value),
//                                               _currentRangeValues.end);
//                                         });
//                                       } else {
//                                         setState(() {
//                                           _currentRangeValues = RangeValues(
//                                               _currentRangeValues.end,
//                                               _currentRangeValues.end);
//                                         });
//                                       }
//                                     },
//                                   )),
//                             ],
//                           ),
//                         ),
//                         Flexible(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Container(
//                                 margin: EdgeInsets.only(left: 5),
//                                 child: Text(
//                                   'ДО',
//                                   style: TextStyle(fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                               Container(
//                                   margin: EdgeInsets.only(left: 5, bottom: 5),
//                                   width: 200,
//                                   height: 30,
//                                   child: TextFormField(
//                                     controller: _priceTo,
//                                     keyboardType: TextInputType.number,
//                                     onChanged: (value) {
//                                       if (int.parse(value) >
//                                           _currentRangeValues.start.round()) {
//                                         setState(() {
//                                           _currentRangeValues = RangeValues(
//                                             _currentRangeValues.start,
//                                             double.parse(value),
//                                           );
//                                         });
//                                       } else {
//                                         setState(() {
//                                           _currentRangeValues = RangeValues(
//                                             _currentRangeValues.start,
//                                             _currentRangeValues.start,
//                                           );
//                                         });
//                                       }
//                                     },
//                                     decoration: InputDecoration(
//                                       border: OutlineInputBorder(),
//                                     ),
//                                   )),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     Container(
//                       margin: EdgeInsets.only(right: 20, left: 20, bottom: 5),
//                       child: RangeSlider(
//                         values: _currentRangeValues,
//                         min: 0,
//                         max: 1000000,
//                         labels: RangeLabels(
//                           _currentRangeValues.start.round().toString(),
//                           _currentRangeValues.end.round().toString(),
//                         ),
//                         onChanged: (RangeValues values) {
//                           setState(() {
//                             _currentRangeValues = values;
//                             _priceFrom.text =
//                                 _currentRangeValues.start.round().toString();
//                             _priceTo.text =
//                                 _currentRangeValues.end.round().toString();
//                           });
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Column(
//                       children: [
//                         categories['parent_id'] == '0'
//                             ? Row(
//                                 children: [
//                                   GestureDetector(
//                                     onTap: () {
//                                       setState(() {
//                                         showCategories = !showCategories;
//                                       });
//                                     },
//                                     child: Container(
//                                       margin: EdgeInsets.fromLTRB(15, 0, 5, 0),
//                                       child: Text(
//                                         'Категории',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             color: Color(0xFF313131),
//                                             fontSize: 20),
//                                       ),
//                                     ),
//                                   ),
//                                   GestureDetector(
//                                     onTap: () {
//                                       setState(() {
//                                         showCategories = !showCategories;
//                                       });
//                                     },
//                                     child: showCategories
//                                         ? Transform.rotate(
//                                             angle: 90 * math.pi / 180,
//                                             child: Icon(
//                                               Icons.arrow_forward_ios,
//                                               size: 16,
//                                               color: globals.blue,
//                                             ),
//                                           )
//                                         : Icon(
//                                             Icons.arrow_forward_ios,
//                                             size: 16,
//                                             color: globals.blue,
//                                           ),
//                                   ),
//                                 ],
//                               )
//                             : Container(),
//                         showCategories
//                             ? Column(
//                                 children: [
//                                   for (var i = 0;
//                                       i < categories['childs'].length;
//                                       i++)
//                                     Container(
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         children: [
//                                           Row(
//                                             children: [
//                                               GestureDetector(
//                                                 onTap: () {
//                                                   setState(() {
//                                                     categories['childs'][i]
//                                                             ['show'] =
//                                                         !categories['childs'][i]
//                                                             ['show'];
//                                                   });
//                                                 },
//                                                 child: Container(
//                                                   margin: categories['childs']
//                                                           [i]['show']
//                                                       ? EdgeInsets.fromLTRB(
//                                                           0, 22, 5, 20)
//                                                       : EdgeInsets.fromLTRB(
//                                                           0, 22, 5, 20),
//                                                   child: Text(
//                                                     categories['childs'][i][
//                                                         'name_' + globals.lang],
//                                                     style: TextStyle(
//                                                         fontWeight:
//                                                             FontWeight.bold,
//                                                         color:
//                                                             Color(0xFF313131),
//                                                         fontSize: 20),
//                                                   ),
//                                                 ),
//                                               ),
//                                               GestureDetector(
//                                                 onTap: () {
//                                                   setState(() {
//                                                     categories['childs'][i]
//                                                             ['show'] =
//                                                         !categories['childs'][i]
//                                                             ['show'];
//                                                   });
//                                                 },
//                                                 child: categories['childs'][i]
//                                                         ['show']
//                                                     ? Transform.rotate(
//                                                         angle:
//                                                             90 * math.pi / 180,
//                                                         child: Icon(
//                                                           Icons
//                                                               .arrow_forward_ios,
//                                                           size: 16,
//                                                           color: globals.blue,
//                                                         ),
//                                                       )
//                                                     : Icon(
//                                                         Icons.arrow_forward_ios,
//                                                         size: 16,
//                                                         color: globals.blue,
//                                                       ),
//                                               ),
//                                             ],
//                                           ),
//                                           Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               for (var j = 0;
//                                                   j <
//                                                       categories['childs'][i]
//                                                               ['childs']
//                                                           .length;
//                                                   j++)
//                                                 GestureDetector(
//                                                   onTap: () {
//                                                     Get.back(result: [
//                                                       categories['childs'][i]
//                                                           ['childs'][j]['id'],
//                                                       _priceFrom.text,
//                                                       _priceTo.text
//                                                     ]);
//                                                   },
//                                                   child: categories['childs'][i]
//                                                           ['show']
//                                                       ? Container(
//                                                           margin: EdgeInsets
//                                                               .fromLTRB(
//                                                                   40, 0, 0, 20),
//                                                           child: Text(
//                                                             categories['childs']
//                                                                         [i][
//                                                                     'childs'][j]
//                                                                 ['name_' +
//                                                                     globals
//                                                                         .lang],
//                                                             style: TextStyle(
//                                                                 fontSize: 20,
//                                                                 color: Color(
//                                                                     0xFF747474)),
//                                                           ),
//                                                         )
//                                                       : Container(),
//                                                 ),
//                                             ],
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                 ],
//                               )
//                             : Container()
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ))
//           : Center(
//               child: CircularProgressIndicator(
//                 color: globals.blue,
//               ),
//             ),
//       floatingActionButton: Container(
//         height: 50,
//         width: double.infinity,
//         margin: EdgeInsets.only(left: 30),
//         child: ElevatedButton(
//           child: Text(
//             'Применить',
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//           onPressed: () {
//             Navigator.pop(context, [widget.id, _priceFrom.text, _priceTo.text]);
//           },
//         ),
//       ),
//     );
//   }
// }
