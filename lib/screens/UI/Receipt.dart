import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:rasseed/screens/my_cards/my_cards.dart';



class Receipt extends StatefulWidget {
  @override
  _ReceiptState createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Color.fromRGBO(69, 57, 137, 1.0));
    return Scaffold(
      backgroundColor: Color.fromRGBO(69, 57, 137, 1.0),

      body: SingleChildScrollView(
        child: Container(


          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20.0,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
              ),
              Container(
                child: Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.only(left: 40.0, right: 40.0, top: 40),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height/1.4 ,
                        child: Card(
                          color: Colors.white,
                          elevation: 4.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 50.0),
                                alignment: Alignment.center,
                                child: Text(
                                  "تم شراء البطاقات بنجاح",
                                  style: TextStyle(
                                      color: Colors.grey.withOpacity(.8),
                                      fontSize: 22),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 40.0),
                                alignment: Alignment.center,
                                child: Text(
                                  "الفاتوره",
                                  style: TextStyle(
                                      color: Color.fromRGBO(69, 57, 137, 1.0),
                                      fontSize: 18),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 00.0),
                                alignment: Alignment.center,
                                child: Text(
                                  "9:00PM  12/24/2018",
                                  style: TextStyle(
                                      color: Colors.grey.withOpacity(.5),
                                      fontSize: 12),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 20.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        "20رس",
                                        style: TextStyle(
                                            color: Colors.grey.withOpacity(.8),
                                            fontSize: 16),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        "1x",
                                        style: TextStyle(
                                            color: Colors.grey.withOpacity(.8),
                                            fontSize: 16),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(right: 10.0),
                                      child: Text(
                                        "بطاقه شحن زين 20رس",
                                        style: TextStyle(
                                            color: Colors.grey.withOpacity(.8),
                                            fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 20.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        "20رس",
                                        style: TextStyle(
                                            color: Colors.grey.withOpacity(.8),
                                            fontSize: 16),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        "1x",
                                        style: TextStyle(
                                            color: Colors.grey.withOpacity(.8),
                                            fontSize: 16),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(right: 10.0),
                                      child: Text(
                                        "بطاقه شحن زين 20رس",
                                        style: TextStyle(
                                            color: Colors.grey.withOpacity(.8),
                                            fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 20.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        "20رس",
                                        style: TextStyle(
                                            color: Colors.grey.withOpacity(.8),
                                            fontSize: 16),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        "1x",
                                        style: TextStyle(
                                            color: Colors.grey.withOpacity(.8),
                                            fontSize: 16),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(right: 10.0),
                                      child: Text(
                                        "بطاقه شحن زين 20رس",
                                        style: TextStyle(
                                            color: Colors.grey.withOpacity(.8),
                                            fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 20.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        "20رس",
                                        style: TextStyle(
                                            color: Colors.grey.withOpacity(.8),
                                            fontSize: 16),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        "1x",
                                        style: TextStyle(
                                            color: Colors.grey.withOpacity(.8),
                                            fontSize: 16),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(right: 10.0),
                                      child: Text(
                                        "بطاقه شحن زين 20رس",
                                        style: TextStyle(
                                            color: Colors.grey.withOpacity(.8),
                                            fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: 15.0, left: 10.0, right: 10.0),
                                color: Colors.grey.withOpacity(.5),
                                width: MediaQuery.of(context).size.width,
                                height: .5,
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 20.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        "20رس",
                                        style: TextStyle(
                                            color: Colors.grey.withOpacity(.8),
                                            fontSize: 16),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(right: 10.0),
                                      child: Text(
                                        "بطاقه شحن زين 20رس",
                                        style: TextStyle(
                                            color: Colors.grey.withOpacity(.8),
                                            fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height / 4,
                      left: MediaQuery.of(context).size.width / 10.6,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 20.0,
                            height: 20.0,
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(69, 57, 137, 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100.0))),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.4,
                            height: .5,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(.6),
                            ),
                          ),
                          Container(
                            width: 20.0,
                            height: 20.0,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(69, 57, 137, 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100.0))),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: MediaQuery.of(context).size.width / 2.5,
                      child: Container(
                        width: 85.0,
                        height: 85.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(69, 57, 137, 1.0),
                            border: Border.all(color: Colors.white, width: 4.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(100.0))),
                        child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(0.0),
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 60.0,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                highlightColor: Color.fromRGBO(69, 57, 137, 1.0),
                splashColor: Color.fromRGBO(69, 57, 137, 1.0),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => My_cards()));
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 120.0,
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      border: Border.all(color: Colors.white)),
                  margin: EdgeInsets.only(top: 20.0),
                  child: Text(
                    "بطاقتي",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
