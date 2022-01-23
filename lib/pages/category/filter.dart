import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:PonyGold/globals.dart' as globals;
import 'package:get/get.dart';
import 'dart:math' as math;

class Filter extends StatefulWidget {
  Filter({Key? key}) : super(key: key);

  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  dynamic categories = [];
  String dropdownValue = 'One';
  dynamic id = Get.arguments;
  bool loading = true;
  bool showCategories = false;
  RangeValues _currentRangeValues = const RangeValues(0, 1000000);
  var _priceFrom = TextEditingController(text: '0');
  var _priceTo = TextEditingController(text: '1000000');

  @override
  void initState() {
    super.initState();
    setState(() {
      loading = false;
    });
    print(id);
    getCategories();
  }

  getCategories() async {
    final response = await http
        .get(Uri.parse('https://ponygold.uz/api/client/category-childs/${id}'));
    final responseJson = jsonDecode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        categories = responseJson;
      });
      print(responseJson['childs']);
      if (responseJson['childs'] != null) {
        for (var i = 0; i < responseJson['childs'].length; i++) {
          dynamic childId = responseJson['childs'][i]['id'];
          final response2 = await http.get(Uri.parse(
              'https://ponygold.uz/api/client/category-childs/$childId'));
          final responseJson2 = jsonDecode(response2.body);
          if (response2.statusCode == 200) {
            setState(() {
              categories['childs'][i]['show'] = false;
              categories['childs'][i]['childs'] = responseJson2['childs'];
            });
          }
        }
      }
    }
    setState(() {
      loading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        backgroundColor: globals.blue,
      ),
      body: loading
          ? SingleChildScrollView(
              child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20, left: 15, bottom: 10),
                      child: Text(
                        'Цена (сум)',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 15, bottom: 5),
                                child: Text(
                                  'ОТ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(left: 15, bottom: 5),
                                  width: 180,
                                  height: 35,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: _priceFrom,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: (value) {
                                      if (int.parse(value) <
                                          _currentRangeValues.end.round()) {
                                        setState(() {
                                          _currentRangeValues = RangeValues(
                                              double.parse(value),
                                              _currentRangeValues.end);
                                        });
                                      } else {
                                        setState(() {
                                          _currentRangeValues = RangeValues(
                                              _currentRangeValues.end,
                                              _currentRangeValues.end);
                                        });
                                      }
                                    },
                                  )),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    left: 5, bottom: 5, right: 15),
                                child: Text(
                                  'ДО',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(
                                      left: 5, bottom: 5, right: 15),
                                  width: 200,
                                  height: 35,
                                  child: TextFormField(
                                    controller: _priceTo,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      if (int.parse(value) >
                                          _currentRangeValues.start.round()) {
                                        setState(() {
                                          _currentRangeValues = RangeValues(
                                            _currentRangeValues.start,
                                            double.parse(value),
                                          );
                                        });
                                      } else {
                                        setState(() {
                                          _currentRangeValues = RangeValues(
                                            _currentRangeValues.start,
                                            _currentRangeValues.start,
                                          );
                                        });
                                      }
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 20, left: 20, bottom: 5),
                      child: RangeSlider(
                        values: _currentRangeValues,
                        min: 0,
                        max: 10000000,
                        labels: RangeLabels(
                          _currentRangeValues.start.round().toString(),
                          _currentRangeValues.end.round().toString(),
                        ),
                        onChanged: (RangeValues values) {
                          setState(() {
                            _currentRangeValues = values;
                            _priceFrom.text =
                                _currentRangeValues.start.round().toString();
                            _priceTo.text =
                                _currentRangeValues.end.round().toString();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        categories['parent_id'] == '0'
                            ? Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        showCategories = !showCategories;
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(15, 0, 5, 0),
                                      child: Text(
                                        'Категории',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF313131),
                                            fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        showCategories = !showCategories;
                                      });
                                    },
                                    child: showCategories
                                        ? Transform.rotate(
                                            angle: 90 * math.pi / 180,
                                            child: Icon(
                                              Icons.arrow_forward_ios,
                                              size: 16,
                                              color: globals.blue,
                                            ),
                                          )
                                        : Icon(
                                            Icons.arrow_forward_ios,
                                            size: 16,
                                            color: globals.blue,
                                          ),
                                  ),
                                ],
                              )
                            : Container(),
                        showCategories
                            ? Column(
                                children: [
                                  for (var i = 0;
                                      i < categories['childs'].length;
                                      i++)
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    categories['childs'][i]
                                                            ['show'] =
                                                        !categories['childs'][i]
                                                            ['show'];
                                                  });
                                                },
                                                child: Container(
                                                  margin: categories['childs']
                                                          [i]['show']
                                                      ? EdgeInsets.fromLTRB(
                                                          0, 22, 5, 20)
                                                      : EdgeInsets.fromLTRB(
                                                          0, 22, 5, 20),
                                                  child: Text(
                                                    categories['childs'][i][
                                                        'name_' + globals.lang],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xFF313131),
                                                        fontSize: 20),
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    categories['childs'][i]
                                                            ['show'] =
                                                        !categories['childs'][i]
                                                            ['show'];
                                                  });
                                                },
                                                child: categories['childs'][i]
                                                        ['show']
                                                    ? Transform.rotate(
                                                        angle:
                                                            90 * math.pi / 180,
                                                        child: Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          size: 16,
                                                          color: globals.blue,
                                                        ),
                                                      )
                                                    : Icon(
                                                        Icons.arrow_forward_ios,
                                                        size: 16,
                                                        color: globals.blue,
                                                      ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              for (var j = 0;
                                                  j <
                                                      categories['childs'][i]
                                                              ['childs']
                                                          .length;
                                                  j++)
                                                GestureDetector(
                                                  onTap: () {
                                                    Get.back(result: [
                                                      categories['childs'][i]
                                                          ['childs'][j]['id'],
                                                      _priceFrom.text,
                                                      _priceTo.text
                                                    ]);
                                                  },
                                                  child: categories['childs'][i]
                                                          ['show']
                                                      ? Container(
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  40, 0, 0, 20),
                                                          child: Text(
                                                            categories['childs']
                                                                        [i][
                                                                    'childs'][j]
                                                                ['name_' +
                                                                    globals
                                                                        .lang],
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                color: Color(
                                                                    0xFF747474)),
                                                          ),
                                                        )
                                                      : Container(),
                                                ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                ],
                              )
                            : Container()
                      ],
                    ),
                  ],
                ),
              ],
            ))
          : Center(
              child: CircularProgressIndicator(
                color: globals.blue,
              ),
            ),
      floatingActionButton: Container(
        height: 50,
        width: double.infinity,
        margin: EdgeInsets.only(left: 30),
        child: ElevatedButton(
          child: Text(
            'Применить',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            Navigator.pop(context, [id, _priceFrom.text, _priceTo.text]);
          },
        ),
      ),
    );
  }
}
