import 'package:flutter/material.dart';
import 'package:PonyGold/globals.dart' as globals;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  dynamic user = {};
  bool loading = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
    });
    getUser();
  }

  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic token = prefs.getString('access_token');
    final response = await http.get(
      Uri.parse('https://ponygold.uz/api/auth/me'),
      headers: {
        // HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    setState(() {
      user = jsonDecode(response.body);
      loading = false;
    });
  }

  signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('access_token');
    prefs.remove('user');
    prefs.remove('password');
    Get.offAllNamed("/login");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Мой профиль'),
          centerTitle: true,
          backgroundColor: globals.blue,
        ),
        body: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                      margin: EdgeInsets.only(bottom: 24),
                      height: 180,
                      width: double.infinity,
                      color: Color(0xFFF4F7FA),
                      child: Column(children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child: Text(
                            user['name'],
                            style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF3133131),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: Text(
                            'ID: ${user['id']}',
                            style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF747474),
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 8, right: 5),
                              child: Text(
                                'Pony Gold:',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 8, right: 5),
                              child: Text(
                                user['pony_golds'],
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF313131)),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 8),
                              child: Image.asset('images/bonus.png'),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: Text(
                            'Купоны: ${user['pony_game_chances']}',
                            style: TextStyle(
                                color: globals.blue,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ]),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 18, left: 18, bottom: 35),
                      padding: EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Color(0xFFECECEC)))),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            child: Text(
                              'Номер телефона: ',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            child: Text(globals.formatPhone(user['phone']),
                                style: TextStyle(
                                    fontSize: 16, color: Color(0xFF747474))),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 15, right: 15),
                      decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFECECEC))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            padding:
                                EdgeInsets.only(top: 15, left: 15, bottom: 15),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom:
                                        BorderSide(color: Color(0xFFECECEC)))),
                            height: 60,
                            child: Text(
                              'Публичная оферта',
                              style: TextStyle(
                                  fontSize: 18, color: Color(0xFF747474)),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed('/game');
                            },
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Color(0xFFECECEC)))),
                              height: 60,
                              padding: EdgeInsets.only(
                                  top: 15, left: 15, bottom: 15),
                              child: Text(
                                'Начать игру',
                                style: TextStyle(
                                    fontSize: 18, color: Color(0xFFF3B231)),
                              ),
                            ),
                          ),
                          Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Color(0xFFECECEC)))),
                              height: 60,
                              padding: EdgeInsets.only(
                                  top: 15, left: 15, bottom: 15),
                              child: GestureDetector(
                                onTap: () {
                                  signOut();
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.logout_rounded,
                                      color: Color(0xFFEB6465),
                                    ),
                                    Text(
                                      'Выйти из аккаунта',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Color(0xFFEB6465)),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 30),
                        child: Text(
                          'Служба поддержки: +998 99 314 42 63',
                          style:
                              TextStyle(fontSize: 16, color: Color(0xFF313131)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
        bottomNavigationBar: globals.bottomBar,
      ),
    );
  }
}
