import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../globals.dart' as globals;

//ignore: must_be_immutable
class BottomBar extends StatefulWidget {
  int? active;
  BottomBar({Key? key, this.active}) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int index = 0;

  onItemTab(int index) {
    print(index);
    if (index != widget.active) {
      setState(() {
        // active = index;
      });
      switch (index) {
        case 0:
          Get.offAllNamed('/');
          break;
        case 1:
          Get.offAllNamed(
            '/basket',
          );
          break;
        case 2:
          Get.offAllNamed('/orders');
          break;
        case 3:
          Get.offAllNamed(
            '/profile',
          );
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: onItemTab,
        currentIndex: widget.active!,
        backgroundColor: globals.white,
        selectedItemColor: globals.blue,
        selectedIconTheme: IconThemeData(color: globals.blue),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_cart_outlined,
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_bag_outlined,
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              label: ''),
        ]);
  }
}

// BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         // showSelectedLabels: false,
//         // showUnselectedLabels: false,
//         onTap: onItemTab,
//         currentIndex: widget.active!,
//         backgroundColor: globals.white,
//         selectedItemColor: globals.black,
        
//         selectedIconTheme: IconThemeData(color: globals.black),
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.home,
//             ),
//             label: 'Главная'
//           ),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.list_alt, color: Color(0xFF828282)),
//               label: 'Мои заказы'),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.person, color: Color(0xFF828282)),
//               label: 'Профиль'),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.headset_mic, color: Color(0xFF828282)),
//               label: 'Поддержка'),
//         ])