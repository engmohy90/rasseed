import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:rasseed/screens/my_cards/my_cards.dart';

class SccessPayfort extends StatefulWidget {
  @override
  _SccessPayfortState createState() => _SccessPayfortState();
}

class _SccessPayfortState extends State<SccessPayfort> {
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Color.fromRGBO(69, 57, 137, 1.0));
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(69, 57, 137, 1.0),
          centerTitle: true,
          title: Text("تم الدفع بنجاح  ",style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.w600),),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.close, color: Colors.white,size: 20.0,), onPressed: (){
              Navigator.of(context).pop();
            }),
          ],
          leading: Container(
            color: Color.fromRGBO(69, 57, 137, 1.0),
          ),
        ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 30, right: 20, left: 20),
                    child: Icon(
                      Icons.email,
                      size: 35,
                    ),
                  ),
                  Text(" "),
                  Padding(
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    child: Text(
                      "",
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("كودك"),
                  Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                    width: 100,
                    height: 35,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          "",
                          style: TextStyle(color: Color.fromRGBO(69, 57, 137, 1.0)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (BuildContext context) =>
                              new My_cards()));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      height: 30,
                      child: Center(child: Text("الذهاب لبطاقاتي  ")),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border:
                          Border.all(color: Color.fromRGBO(69, 57, 137, 1.0))),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    child: Text(
                      " ",
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}

