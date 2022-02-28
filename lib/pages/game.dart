import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'dart:math';
import 'package:PonyGold/globals.dart' as globals;

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
  String text = 'ВЫБЕРИТЕ КАРТОЧКУ';

  startGame(num) {
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
        appBar: AppBar(
          backgroundColor: globals.blue,
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/game/bg.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 100, bottom: 15),
                child: Text(
                  'Уровень $level',
                  style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Text(
                  text,
                  style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
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
                        child: Image.asset(
                          'images/game/card-front.png',
                          width: MediaQuery.of(context).size.width * 0.3,
                        )),
                    back: Image.asset(
                      'images/game/card-front.png',
                      width: MediaQuery.of(context).size.width * 0.3,
                    ),
                  )),
                  Center(
                      child: FlipCard(
                          key: cardKey2,
                          flipOnTouch: false,
                          front: GestureDetector(
                              onTap: () => startGame(2),
                              child: Image.asset(
                                'images/game/card-front.png',
                                width: MediaQuery.of(context).size.width * 0.3,
                              )),
                          back: Image.asset(
                            'images/game/card-front.png',
                            width: MediaQuery.of(context).size.width * 0.3,
                          ))),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              // Доделать
              // Container(
              //   child: Text('data'),
              // )
            ],
          ),
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
                style: ElevatedButton.styleFrom(primary: win ? globals.blue : Color(0xFF747474)),
                onPressed: () {
                  if (win) {
                    if (card == 1) {
                      cardKey.currentState!.toggleCard();
                    }
                    if (card == 2) {
                      cardKey2.currentState!.toggleCard();
                    }
                    setState(() {
                      text = ' ВЫБЕРИТЕ КАРТОЧКУ';
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
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
                style: ElevatedButton.styleFrom(primary: Color(0xFF594c88)),
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
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: win ? Colors.white : Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  dynamic cards = [
    {'id': 1, 'passed': false, 'card1': false, 'card2': false, 'pony_golds': 3000, 'totalPonyGolds': 3000, 'level': 1, 'show': true},
    {'id': 2, 'passed': false, 'card1': false, 'card2': false, 'pony_golds': 2000, 'totalPonyGolds': 5000, 'level': 2, 'show': false},
    {'id': 3, 'passed': false, 'card1': false, 'card2': false, 'pony_golds': 5000, 'totalPonyGolds': 10000, 'level': 3, 'show': false},
    {'id': 4, 'passed': false, 'card1': false, 'card2': false, 'pony_golds': 10000, 'totalPonyGolds': 20000, 'level': 4, 'show': false},
    {'id': 5, 'passed': false, 'card1': false, 'card2': false, 'pony_golds': 30000, 'totalPonyGolds': 50000, 'level': 5, 'show': false},
    {'id': 6, 'passed': false, 'card1': false, 'card2': false, 'pony_golds': 50000, 'totalPonyGolds': 100000, 'level': 6, 'show': false},
    {'id': 7, 'passed': false, 'card1': false, 'card2': false, 'pony_golds': 100000, 'totalPonyGolds': 200000, 'level': 7, 'show': false},
    {'id': 8, 'passed': false, 'card1': false, 'card2': false, 'pony_golds': 300000, 'totalPonyGolds': 500000, 'level': 8, 'show': false},
    {'id': 9, 'passed': false, 'card1': false, 'card2': false, 'totalPonyGolds': 1000000, 'level': 9, 'show': false},
    {'id': 10, 'passed': false, 'card1': false, 'card2': false, 'card3': false, 'totalPonyGolds': 3000000, 'level': 10, 'show': false},
  ];
}
