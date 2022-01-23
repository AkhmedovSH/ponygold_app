import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:PonyGold/globals.dart' as globals;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConfirmOtp extends StatefulWidget {
  ConfirmOtp({Key? key}) : super(key: key);

  @override
  _ConfirmOtpState createState() => _ConfirmOtpState();
}

class _ConfirmOtpState extends State<ConfirmOtp> {
  String otp = '';

  checkOtp() async {
    print(globals.phone);
    final response = await http.post(
      Uri.parse('https://ponygold.uz/api/auth/check-otp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'otp': otp, 'phone': globals.phone}),
    );
    if (response.statusCode == 200) {
      Navigator.pushNamed(context, '/register-step-2');
    }
    if (response.statusCode == 400) {
      globals.showToast(context, jsonDecode(response.body)['error']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: globals.blue,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Подтверждение',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            Container(
                margin: EdgeInsets.only(top: 20),
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.red)),
                    labelText: 'Введите код из смс',
                  ),
                  onChanged: (value) {
                    setState(() {
                      otp = value;
                    });
                  },
                )),
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
                  checkOtp();
                },
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 60),
            child: Text('Не пришел код?', style: TextStyle(fontSize: 18)),
          ),
          Container(
              margin: EdgeInsets.only(bottom: 60),
              child: TextButton(
                  onPressed: () {},
                  child: Text('Отправить еще раз',
                      style: TextStyle(
                          color: Colors.greenAccent[400], fontSize: 18))))
        ],
      ),
    );
  }
}
