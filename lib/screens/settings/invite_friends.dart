import 'dart:async';

import 'package:flutter/material.dart';
//import 'package:advanced_share/advanced_share.dart' show AdvancedShare;
import 'package:share/share.dart';


class Invite_friends extends StatefulWidget {
  @override
  _Invite_friendsState createState() => _Invite_friendsState();
}

class _Invite_friendsState extends State<Invite_friends> {
  String code_mandoob = "GFDSE";
  var loading = true;
  final scaffoldKey = new GlobalKey<ScaffoldState>();


  void handleResponse(response, {String appName}) {
    if (response == 0) {
      print("failed.");
    } else if (response == 1) {
      print("success");
    } else if (response == 2) {
      print("application isn't installed");
      if (appName != null) {
        scaffoldKey.currentState.showSnackBar(new SnackBar(
          backgroundColor: Colors.red,
          content: new Text("${appName} isn't installed."),
          duration: new Duration(seconds: 4),
        ));
      }
    }
  }

  void generic() {
//    AdvancedShare.generic(
//      msg: "Its good.",
//      title: "Share with Advanced Share",
//    ).then((response){
//      print(response);
//      handleResponse(response);
//    });


  }

  void whatsapp() {
//    AdvancedShare
//        .whatsapp(msg: "It's okay :)")
//        .then((response) {
//      handleResponse(response, appName: "Whatsapp");
//    });
  }

  void gmail() {
//    AdvancedShare
//        .gmail(subject: "Advanced Share", msg: "Mail body")
//        .then((response) {
//      handleResponse(response, appName: "Gmail");
//    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(69, 57, 137, 1.0),
        title: Text("دعوة صديق"),
        centerTitle: true,
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
              Text("احصل على 5 نقاط مجانا"),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: Text(
                  "شارك الكود الخاص بك مع اصدقاءك وبعد تسجيلهم باستخدام هذا الكود , ستحصل على 5 نقاط بعد أول عملية شراء لهم . وفي المقابل سيحصلون على هدية ترحيبية بقيمة 5 نقط!",
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
                      code_mandoob,
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
                  Share.share(code_mandoob);
                  setState(() {loading = true;});
                  Timer(Duration(seconds: 5), () =>setState(() {loading = false;}));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: 30,
                  child: Center(child: Text("دعوة صديق ")),
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
                  "شارك الكود الخاص بك مع اصدقاءك من خلال منصات التواصل الاجتماعي او ارساله من خلال رساله عبر البريد الالكتروني ",
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
