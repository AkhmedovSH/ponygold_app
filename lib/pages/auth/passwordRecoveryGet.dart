import 'package:flutter/material.dart';
import 'package:PonyGold/globals.dart' as globals;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PasswordRecoveryGet extends StatefulWidget {
  PasswordRecoveryGet({Key? key}) : super(key: key);

  @override
  _PasswordRecoveryGetState createState() => _PasswordRecoveryGetState();
}

class _PasswordRecoveryGetState extends State<PasswordRecoveryGet> {
  String phone = '';
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
              'Восстановление пароля',
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
                    border: OutlineInputBorder(),
                    labelText: 'Номер телефона',
                  ),
                  onChanged: (value) {
                    setState(() {
                      phone = value;
                    });
                  },
                )),
            Padding(padding: EdgeInsets.only(top: 20)),
            Container(
              child: ElevatedButton(
                child: Text(
                  'Получить код',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50)),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/password-recovery-confirm', (route) => true);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
