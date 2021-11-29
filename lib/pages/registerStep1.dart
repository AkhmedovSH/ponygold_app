import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:PonyGold/globals.dart' as globals;
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class RegisterStep1 extends StatefulWidget {
  RegisterStep1({Key? key}) : super(key: key);

  @override
  _RegisterStep1State createState() => _RegisterStep1State();
}

class _RegisterStep1State extends State<RegisterStep1> {
  String name = '';
  String phone = '';
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  var maskFormatter = new MaskTextInputFormatter(
      mask: '+### (##) ### ## ##', filter: {"#": RegExp(r'[0-9]')});

  void register(context) async {
    final response = await http.post(
      Uri.parse('https://ponygold.uz/api/auth/check-user-exist'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'phone': maskFormatter.getUnmaskedText()
      }),
    );
    final responseJson = jsonDecode(response.body);
    if (response.statusCode == 200) {
      globals.phone = phone;
      Navigator.pushNamed(context, '/confirm-otp');
    }
    if (response.statusCode == 400) {
      globals.showToast(context, responseJson['error']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: globals.blue,),
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
                        margin: EdgeInsets.only(top: 30),
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
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Имя',
                          ),
                          onChanged: (value) {
                            setState(() {
                              name = value;
                            });
                          },
                        )),
                  ),
                  Form(
                    key: _formKey2,
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
                            // contentPadding: EdgeInsets.symmetric(vertical: 10),
                            labelStyle: TextStyle(fontSize: 16),
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 10, bottom: 2),
                              child: Text(
                                "+998 (99) 999 99 99",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            prefixIconConstraints:
                                BoxConstraints(minWidth: 0, minHeight: 0),
                          ),
                          onChanged: (value) {
                            setState(() {
                              phone = value;
                            });
                          },
                          onFieldSubmitted: (val) {
                            if (_formKey.currentState!.validate() &&
                                _formKey2.currentState!.validate()) {
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
                            _formKey2.currentState!.validate()) {
                          register(context);
                        }
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 60),
                        child: Text('Уже есть аккаунт?',
                            style: TextStyle(fontSize: 20)),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 60),
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
