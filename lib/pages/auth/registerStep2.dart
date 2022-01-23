import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:PonyGold/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterStep2 extends StatefulWidget {
  RegisterStep2({Key? key}) : super(key: key);

  @override
  _RegisterStep2State createState() => _RegisterStep2State();
}

class _RegisterStep2State extends State<RegisterStep2> {
  String login = '';
  String password = '';
  String repeatPassword = '';
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();

  void register(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse('https://ponygold.uz/api/auth/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'login': login,
        'password': password,
        'phone': globals.phone
      }),
    );
    final responseJson = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final data = await http.post(
        Uri.parse('https://ponygold.uz/api/auth/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
            <String, String>{'phone': globals.phone, 'password': password}),
      );
      final dataJson = jsonDecode(data.body);
      prefs.setString('access_token', dataJson['access_token'].toString());
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
    if (response.statusCode == 400) {
      globals.showToast(context, responseJson['error']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: globals.blue,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Регистрация',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Form(
                    key: _formKey,
                    child: Container(
                        margin: EdgeInsets.only(top: 20),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Обязательное поле';
                            }
                            if (value.length < 4) {
                              return 'Минимум 4 символов';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Логин',
                          ),
                          onChanged: (value) {
                            setState(() {
                              login = value;
                            });
                          },
                        )),
                  ),
                  Form(
                    key: _formKey2,
                    child: Container(
                        margin: EdgeInsets.only(top: 20),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Обязательное поле';
                            }
                            if (value.length < 4) {
                              return 'Минимум 4 символов';
                            }
                            return null;
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Пароль',
                          ),
                          onChanged: (value) {
                            setState(() {
                              password = value;
                            });
                          },
                        )),
                  ),
                  Form(
                    key: _formKey3,
                    child: Container(
                        margin: EdgeInsets.only(top: 20),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Обязательное поле';
                            }
                            if (value != password) {
                              return 'Пароли не совпадают';
                            }
                            return null;
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Повторите пароль',
                          ),
                          onChanged: (value) {
                            setState(() {
                              repeatPassword = value;
                            });
                          },
                          onFieldSubmitted: (val) {
                            if (_formKey.currentState!.validate() &&
                                _formKey2.currentState!.validate() &&
                                _formKey3.currentState!.validate()) {
                              register(context);
                            }
                          },
                        )),
                  ),
                  Padding(padding: EdgeInsets.only(top: 20)),
                  Container(
                    child: ElevatedButton(
                      child: Text(
                        'Подтвердить',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50)),
                      onPressed: () {
                        if (_formKey.currentState!.validate() &&
                            _formKey2.currentState!.validate() &&
                            _formKey3.currentState!.validate()) {
                          register(context);
                        }
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 40),
                        child: Text('Уже есть аккаунт?',
                            style: TextStyle(fontSize: 20)),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 40),
                          child: TextButton(
                              onPressed: () {
                                Navigator.pushNamedAndRemoveUntil(
                                    context, '/login', (route) => false);
                              },
                              child: Text('Войти',
                                  style: TextStyle(
                                      color: Colors.greenAccent[400],
                                      fontSize: 20))))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
