import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'dart:math';

class Game extends StatefulWidget {
  Game({Key? key}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  bool clicked = true;
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  GlobalKey<FlipCardState> cardKey2 = GlobalKey<FlipCardState>();
  int level = 1;
  int card = 1;
  bool win = false;
  bool win1 = false;
  bool win2 = false;
  String text = 'Выберите один из двух вариантов';
  startGame(num) {
    // setState(() {
    //   clicked = false;
    // });
    var random = (Random().nextInt(2));
    if (num == 1) {
      if (random == 0) {
        cardKey.currentState!.toggleCard();
        setState(() {
          level += 1;
          card = 1;
          win = true;
          text = 'Правильно! ваш выигрыш 3 000 PG';
        });
      }
      if (random == 1) {
        cardKey.currentState!.toggleCard();
        cardKey2.currentState!.toggleCard();
        setState(() {
          win = false;
          text = 'К сожалению, вы проиграли';
        });
      }
    }
    if (num == 2) {
      if (random == 0) {
        cardKey2.currentState!.toggleCard();
        setState(() {
          level += 1;
          card = 2;
          win = true;
        });
      }
      if (random == 1) {
        cardKey.currentState!.toggleCard();
        cardKey2.currentState!.toggleCard();
        setState(() {
          win = false;
          text = 'К сожалению, вы проиграли';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 100, bottom: 15),
              child: Text(
                'Уровень $level',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Text(
                text,
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF313131),
                    fontWeight: FontWeight.w500),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child: FlipCard(
                  key: cardKey,
                  flipOnTouch: false,
                  front: GestureDetector(
                    onTap: () => startGame(1),
                    child: Container(
                      margin: EdgeInsets.only(right: 30),
                      decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFECECEC))),
                      height: 100,
                      width: 130,
                      child: Text('Front'),
                    ),
                  ),
                  back: Container(
                    margin: EdgeInsets.only(right: 30),
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFECECEC))),
                    height: 100,
                    width: 130,
                    child: Text('Back'),
                  ),
                )),
                Center(
                    child: FlipCard(
                  key: cardKey2,
                  flipOnTouch: false,
                  front: GestureDetector(
                    onTap: () => startGame(2),
                    child: Container(
                      margin: EdgeInsets.only(right: 30),
                      decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFECECEC))),
                      height: 100,
                      width: 130,
                      child: Text('Front'),
                    ),
                  ),
                  back: Container(
                    margin: EdgeInsets.only(right: 30),
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFECECEC))),
                    height: 100,
                    width: 130,
                    child: Text('Back'),
                  ),
                )),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            // Доделать
            // Container(
            //   child: Text('data'),
            // )
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(
                left: 30,
              ),
              height: 48,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: win ? Color(0xFF5986E2) : Color(0xFF747474)),
                onPressed: () {
                  if (win) {
                    if (card == 1) {
                      cardKey.currentState!.toggleCard();
                    }
                    if (card == 2) {
                      cardKey2.currentState!.toggleCard();
                    }
                    setState(() {
                      text = 'Выберите один из двух вариантов';
                    });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 8),
                      child: Text(
                        'Продолжить',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 30, top: 15, bottom: 15),
              height: 48,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Color(0xFFEB5757)),
                onPressed: () {
                  // Get.back();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 8),
                      child: Text(
                        'Выйти',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: win ? Colors.white : Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
