import 'package:flutter/material.dart';
 import 'package:rasseed/screens/my_cards/pervious_cards.dart';

import 'new_cards.dart';



class My_cards extends StatefulWidget {
  @override
  _My_cardsState createState() => _My_cardsState();
}

class _My_cardsState extends State<My_cards> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Color.fromRGBO(69, 57, 137, 1.0),
            bottom: TabBar(
              tabs: [
                Tab(
                  child: Text("بطاقات مستخدمة"),
                ),
                Tab(
                  child: Text("بطاقات جديدة"),
                ),
              ],
            ),
            title: Text("بطاقاتي"),
            leading: Container(),
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 20.0,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          ),
          body: TabBarView(
            children: [
              pervious_cards(),
              new_cards(),
            ],
          ),
        ),
      ),
    );
  }
}
