import 'package:flutter/material.dart';
import 'package:PonyGold/globals.dart' as globals;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PasswordRecoveryConfirm extends StatefulWidget {
  PasswordRecoveryConfirm({Key? key}) : super(key: key);

  @override
  _PasswordRecoveryConfirmState createState() =>
      _PasswordRecoveryConfirmState();
}

class _PasswordRecoveryConfirmState extends State<PasswordRecoveryConfirm> {
  String otp = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: globals.blue,),
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
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.red)),
                    labelText: 'Введите код из сообщения',
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
                onPressed: () {},
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
