import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Intro extends StatefulWidget {
  Intro({Key? key}) : super(key: key);

  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  dynamic lang;
  dynamic accessToken;
  @override
  void initState() {
    super.initState();
    getLang();
  }

  getLang() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString('access_token');
    setState(() {
      lang = prefs.getString('lang');
      accessToken = prefs.getString('access_token');
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (lang == null) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/language', (route) => false);
      } else {
        if (accessToken == null) {
          Navigator.pushNamedAndRemoveUntil(
              context, '/login', (route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        color: Colors.blue[500],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Image(image: AssetImage('images/logo.png')),
            ])
          ],
        ),
      ),
    );
  }
}
