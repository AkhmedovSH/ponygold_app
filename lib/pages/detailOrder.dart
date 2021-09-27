import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:PonyGold/globals.dart' as globals;
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DetailOrder extends StatefulWidget {
  DetailOrder({Key? key}) : super(key: key);

  @override
  _DetailOrderState createState() => _DetailOrderState();
}

class _DetailOrderState extends State<DetailOrder> {
  dynamic order = '';
  @override
  void initState() {
    super.initState();
    setState(() {
      order = Get.arguments;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Мои заказы'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Container(
        padding: EdgeInsets.fromLTRB(18, 20, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 5),
              child: Text(
                'Заказ№${order['id']}',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF313131)),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Text(
                globals.formatDate(order['created_at']),
                style: TextStyle(color: Color(0xFF747474)),
              ),
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  child: Text(
                    order['courier_id'] == '0'
                        ? 'Курьер не назначен   '
                        : 'Курьер: ',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(bottom: 5),
                    child: Text(
                      order['courier_id'] == '0'
                          ? ''
                          : order['courier']['name'] +
                              ' ' +
                              order['courier']['surname'],
                      style: TextStyle(
                          color: Color(0xFF747474),
                          fontWeight: FontWeight.bold),
                    )),
              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: 13),
              child: Text(
                globals.formatPhone(order['courier']['phone']),
                style: TextStyle(
                    color: Color(0xFF747474), fontWeight: FontWeight.bold),
              ),
            ),
            Row(children: [
              Container(
                margin: EdgeInsets.only(bottom: 15, right: 10),
                child: Image.asset('images/card.png'),
              ),
              Container(
                margin: EdgeInsets.only(
                  bottom: 15,
                ),
                child: Text(
                  'Форма оплаты: ',
                  style: TextStyle(fontSize: 16, color: Color(0xFF313131)),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 15),
                child: Text(
                  order['payment_type'] == '0'
                      ? 'Наличные'
                      : order['payment_type'] == '1'
                          ? 'Пластиковой картой курьеру'
                          : order['payment_type'] == '2'
                              ? 'Payme'
                              : '',
                  style: TextStyle(color: Color(0xFF747474)),
                ),
              )
            ]),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 15, right: 10),
                  child: Image.asset('images/box.png'),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 15),
                  child: Text('Товары: ${order['total_amount']}сум.',
                      style: TextStyle(fontSize: 16, color: Color(0xFF313131))),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 15, right: 10),
                  child: Image.asset('images/car.png'),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 15),
                  child: Text('Доставка: 250 000 000сум.',
                      style: TextStyle(fontSize: 16, color: Color(0xFF313131))),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: 15),
              child: Text('Состав заказа',
                  style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF313131),
                      fontWeight: FontWeight.bold)),
            ),
            Column(
              children: [
                for (var i = 0; i < order['order_products'].length; i++)
                  Stack(
                    children: [
                      Container(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 15),
                          width: double.infinity,
                          // margin: EdgeInsets.only(left: 15, bottom: 15),
                          child: Text(
                            order['order_products'][i]['name'],
                            style: TextStyle(
                                color: Color(0xFF313131),
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            margin: EdgeInsets.only(right: 15, bottom: 10),
                            child: Text(
                              'x' +
                                  order['order_products'][i]['quantity']
                                      .toString(),
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(
                                  0xFF313131,
                                ),
                              ),
                            ),
                          ))
                    ],
                  )
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 15)),
            Text('Сумма заказа: 125 000 000 сум',
                style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF313131),
                    fontWeight: FontWeight.bold))
          ],
        ),
      )),
      bottomNavigationBar: globals.bottomBar,
    );
  }
}
