import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:PonyGold/globals.dart' as globals;

class Cities extends StatefulWidget {
  Cities({Key? key}) : super(key: key);

  @override
  _CitiesState createState() => _CitiesState();
}

class _CitiesState extends State<Cities> {
  dynamic cities = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      loading = false;
    });
    getCities();
  }

  sorting(arr) {
    dynamic parent = [];
    dynamic children = [];
    for (var i = 0; i < arr.length; i++) {
      if (arr[i]['parent_id'] == '0') {
        arr[i]['show'] = false;
        arr[i]['children'] = [];
        parent.add(arr[i]);
      } else {
        children.add(arr[i]);
      }
    }
    // print(parent);
    // print(children);
    for (var i = 0; i < parent.length; i++) {
      for (var j = 0; j < children.length; j++) {
        if (parent[i]['id'].toString() == children[j]['parent_id'].toString()) {
          parent[i]['children'].add(children[j]);
        }
      }
    }
    return parent;
  }

  getCities() async {
    final response = await globals.get('/api/client/cities', context);
    setState(() {
      cities = sorting(response);
      loading = true;
    });
  }

  selectCity(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response =
        await http.get(Uri.parse('https://ponygold.uz/api/support/city/${id}'));
    if (response.statusCode == 200) {
      prefs.setString('city', jsonEncode(jsonDecode(response.body)));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: loading
          ? Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  for (var i = 0; i < cities.length; i++)
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              final copy = cities;
                              copy[i]['show'] = !copy[i]['show'];
                              setState(() {
                                cities = copy;
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 10),
                              // margin: EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${cities[i]['name']}',
                                    style: TextStyle(
                                        fontSize: 18, color: Color(0xFF747474)),
                                  ),
                                  cities[i]['show']
                                      ? Icon(
                                          Icons.expand_more,
                                          size: 24,
                                          color: Color(0xFF5986E2),
                                        )
                                      : Icon(
                                          Icons.chevron_right,
                                          size: 24,
                                          color: Color(0xFF5986E2),
                                        )
                                ],
                              ),
                            ),
                          ),
                          cities[i]['show']
                              ? Container(
                                  // width: double.infinity,
                                  margin: EdgeInsets.only(left: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      for (var j = 0;
                                          j < cities[i]['children'].length;
                                          j++)
                                        GestureDetector(
                                            onTap: () {
                                              selectCity(cities[i]['children']
                                                  [j]['id']);
                                            },
                                            child: Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 5),
                                                child: Text(
                                                    cities[i]['children'][j]
                                                        ['name'],
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Color(
                                                            0xFF747474)))))
                                    ],
                                  ),
                                )
                              : Container()
                        ],
                      ),
                    )
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                color: Color(0xFF5986E2),
              ),
            ),
    );
  }
}
