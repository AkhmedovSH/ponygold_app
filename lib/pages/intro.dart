import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:PonyGold/globals.dart' as globals;

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
    globals.checkLength(3);
    setState(() {});
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
        color: Color(0xFF00B4AA),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              SvgPicture.asset(
                'images/logo.svg',
                color: Colors.white,
                width: 70,
                height: 70,
              ),
              // Image(image: AssetImage('images/logo.png')),
            ])
          ],
        ),
      ),
    );
  }
}
