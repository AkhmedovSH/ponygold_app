import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:PonyGold/globals.dart' as globals;
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String phone = '';
  dynamic password = '';
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  var maskFormatter = new MaskTextInputFormatter(
      mask: '+### (##) ### ## ##', filter: {"#": RegExp(r'[0-9]')});

  void login(context) async {
    final response = await http.post(
      Uri.parse('https://ponygold.uz/api/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{'phone': maskFormatter.getUnmaskedText(), 'password': password}),
    );
    final responseJson = jsonDecode(response.body);
    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('access_token', responseJson['access_token']);
      prefs.setString('user', jsonEncode(responseJson['user']));
      prefs.setString('password', password.toString());
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
              alignment: Alignment.center,
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Вход',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Container(
                        margin: EdgeInsets.only(top: 20),
                        child: TextFormField(
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(19),
                            maskFormatter
                          ],
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Обязательное поле';
                            }
                            if (value.length < 9) {
                              return 'Минимум 9 символов';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: '+998 (99) 999 99 99',
                            // prefixIcon: Padding(
                            //   padding: EdgeInsets.only(left: 10, bottom: 2),
                            //   child: Text(
                            //     "+998",
                            //     style: TextStyle(fontSize: 16),
                            //   ),
                            // ),
                            // prefixIconConstraints:
                            //     BoxConstraints(minWidth: 0, minHeight: 0),
                          ),
                          onChanged: (value) {
                            setState(() {
                              phone = value;
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
                              return 'Минимум 4 символа';
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
                          onFieldSubmitted: (val) {
                            if (_formKey.currentState!.validate() &&
                                _formKey2.currentState!.validate()) {
                              login(context);
                            }
                          },
                        )),
                  ),
                  Padding(padding: EdgeInsets.only(top: 20)),
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate() &&
                            _formKey2.currentState!.validate()) {
                          login(context);
                        }
                      },
                      child: Text(
                        'Войти',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50)),
                    ),
                  ),
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey))),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/password-recovery-get');
                      },
                      child: Text('Забыли пароль?',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 35)),
                  Container(
                    margin: EdgeInsets.only(bottom: 15),
                    child: TextButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/register-step-1', (route) => false);
                        },
                        child: Text('Регистрация',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.greenAccent[400],
                                fontWeight: FontWeight.w600))),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
