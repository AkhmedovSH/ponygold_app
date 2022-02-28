import 'package:PonyGold/pages/home/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:PonyGold/globals.dart' as globals;
// Pages

import 'package:PonyGold/pages/home/index.dart';
import 'package:PonyGold/pages/auth/language.dart';
import 'package:PonyGold/pages/auth/login.dart';
import 'package:PonyGold/pages/auth/passwordRecoveryGet.dart';
import 'package:PonyGold/pages/auth/passwordRecoveryConfirm.dart';
import 'package:PonyGold/pages/auth/confirmOtp.dart';
import 'package:PonyGold/pages/auth/registerStep1.dart';
import 'package:PonyGold/pages/auth/registerStep2.dart';
import 'package:PonyGold/pages/intro.dart';
import 'package:PonyGold/pages/detail.dart';
import 'package:PonyGold/pages/category/categories.dart';
import 'package:PonyGold/pages/category/filter.dart';
import 'package:PonyGold/pages/home/profile.dart';
import 'package:PonyGold/pages/home/basket.dart';
import 'package:PonyGold/pages/orderPlacement.dart';
import 'package:PonyGold/pages/googleMap.dart';
import 'package:PonyGold/pages/home/orders.dart';
import 'package:PonyGold/pages/detailOrder.dart';
import 'package:PonyGold/pages/search.dart';
import 'package:PonyGold/pages/game.dart';
import 'package:PonyGold/pages/cities.dart';

void main() async {
  Locale lang = Locale('ru');
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getString('lang') == null) {
    lang = Locale('ru');
  } else {
    dynamic selectedLang = prefs.getString('lang');
    lang = Locale(selectedLang);
  }
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(GetMaterialApp(
    popGesture: true,
    locale: lang,
    defaultTransition: Transition.leftToRight,
    transitionDuration: Duration(milliseconds: 250),
    debugShowCheckedModeBanner: false,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: ThemeData(
        backgroundColor: const Color(0xFFFFFFFF),
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        primaryColor: globals.blue,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: globals.blue,
          ),
        ),
        fontFamily: 'ProDisplay',
        textTheme: ThemeData.light().textTheme.copyWith(headline6: TextStyle(fontFamily: 'ProDisplay'))),
    initialRoute: '/intro',
    onGenerateRoute: RouteGenerator.generateRoute,
    // routes: {
    //   '/intro': (context) => Intro(),
    //   '/language': (context) => Language(),
    //   '/login': (context) => Login(),
    //   '/password-recovery-get': (context) => PasswordRecoveryGet(),
    //   '/password-recovery-confirm': (context) => PasswordRecoveryConfirm(),
    //   '/confirm-otp': (context) => ConfirmOtp(),
    //   '/register-step-1': (context) => RegisterStep1(),
    //   '/register-step-2': (context) => RegisterStep2(),

    //   '/': (context) => Index(),
    //   '/detail': (context) => Detail(),
    //   '/categories': (context) => Categories(),
    //   '/profile': (context) => Profile(),
    //   '/basket': (context) => Basket(),
    //   '/order-placement': (context) => OrderPlacement(),
    //   '/google-map': (context) => MapSample(),
    //   '/orders': (context) => Orders(),
    //   '/detail-order': (context) => DetailOrder(),
    //   '/search': (context) => Search(),
    // },
  ));
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // print(settings.name);
    switch (settings.name) {
      case '/dashboard':
        return GetPageRoute(
          settings: settings,
          page: () => Dashboard(),
          transition: Transition.rightToLeft,
        );
      case '/order-placement':
        return GetPageRoute(
          settings: settings,
          page: () => OrderPlacement(),
          transition: Transition.rightToLeft,
        );
      case '/google-map':
        return GetPageRoute(
          settings: settings,
          page: () => MapSample(),
          transition: Transition.rightToLeft,
        );
      case '/orders':
        return GetPageRoute(
          settings: settings,
          page: () => Orders(),
          transition: Transition.rightToLeft,
        );
      case '/detail-order':
        return GetPageRoute(
          settings: settings,
          page: () => DetailOrder(),
          transition: Transition.rightToLeft,
        );
      case '/search':
        return GetPageRoute(
          settings: settings,
          page: () => Search(),
          transition: Transition.rightToLeft,
        );

      case '/confirm-otp':
        return GetPageRoute(
          settings: settings,
          page: () => ConfirmOtp(),
          transition: Transition.rightToLeft,
        );
      case '/register-step-1':
        return GetPageRoute(
          settings: settings,
          page: () => RegisterStep1(),
          transition: Transition.rightToLeft,
        );
      case '/register-step-2':
        return GetPageRoute(
          settings: settings,
          page: () => RegisterStep2(),
          transition: Transition.rightToLeft,
        );
      case '/detail':
        return GetPageRoute(
          settings: settings,
          page: () => Detail(),
          transition: Transition.rightToLeft,
        );
      case '/categories':
        return GetPageRoute(
          settings: settings,
          page: () => Categories(),
          transition: Transition.rightToLeft,
        );
      case '/filter':
        return GetPageRoute(
          settings: settings,
          page: () => Filter(),
          transition: Transition.rightToLeft,
        );
      case '/basket':
        return GetPageRoute(
          settings: settings,
          page: () => Basket(),
          transition: Transition.rightToLeft,
        );

      case '/intro':
        return GetPageRoute(
          settings: settings,
          page: () => Intro(),
          transition: Transition.rightToLeft,
        );
      case '/language':
        return GetPageRoute(
          settings: settings,
          page: () => Language(),
          transition: Transition.rightToLeft,
        );
      case '/login':
        return GetPageRoute(
          settings: settings,
          page: () => Login(),
          transition: Transition.rightToLeft,
        );
      case '/password-recovery-get':
        return GetPageRoute(
          settings: settings,
          page: () => PasswordRecoveryGet(),
          transition: Transition.rightToLeft,
        );
      case '/password-recovery-confirm':
        return GetPageRoute(
          settings: settings,
          page: () => PasswordRecoveryConfirm(),
          transition: Transition.rightToLeft,
        );
      case '/profile':
        return GetPageRoute(
          settings: settings,
          page: () => Profile(),
          transition: Transition.rightToLeft,
        );
      case '/game':
        return GetPageRoute(
          settings: settings,
          page: () => Game(),
          transition: Transition.rightToLeft,
        );
      case '/cities':
        return GetPageRoute(
          settings: settings,
          page: () => Cities(),
          transition: Transition.rightToLeft,
        );
      default:
        return GetPageRoute(
          settings: settings,
          page: () => Index(),
          transition: Transition.fade,
        );

      // }
    }
  }
}
