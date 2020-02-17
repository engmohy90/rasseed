import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rasseed/main.dart';
import 'package:rasseed/screens/UI/AccountStatment.dart';
import 'package:rasseed/screens/UI/InvitationPoints.dart';
import 'package:rasseed/screens/my_cards/my_cards.dart';
import 'package:rasseed/utils/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ArchiveOperations.dart';
import 'Setting.dart';
import 'invite_friends.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String currentBalance;
  String userPoints;
  String clientName;
  String clientPhone;

  GlobalKey<ScaffoldState> profileScaffoldKey = GlobalKey();

  logoutUser() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        content: Container(
          height: MediaQuery.of(context).size.height / 4,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 15.0),
                child: Text(
                  "هل تريد تسجيل الخروج؟",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 40.0),
                      child: InkWell(
                        onTap: () async {
                          Loader.showUnDismissibleLoader(context);
                          SharedPreferences pref =
                              await SharedPreferences.getInstance();
                          pref.clear().then((dataCleared) {
                            if (dataCleared)
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyApp()),
                                  (Route<dynamic> route) => false);
                            else {
                              Loader.hideDialog(context);
                              profileScaffoldKey.currentState
                                  .showSnackBar(SnackBar(
                                backgroundColor: Colors.red,
                                content: Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Text(
                                      'فشل تسجيل الخروج!',
                                      textAlign: TextAlign.center,
                                    )),
                              ));
                            }
                          });
                        },
                        child: Text(
                          "خروج",
                          style: TextStyle(
                              fontSize: 16,
                              color: Color.fromRGBO(69, 57, 137, 1.0),
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                    Container(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "إلغاء",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> getClientName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("full_name");
  }

  Future<String> getClientPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("phone");
  }

  Future<String> getUserSID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('\n\n\n user sid: ${prefs.getString('client_auth')}\n\n\n');
    return prefs.getString('client_auth');
  }

  /*https://app.rasseed.com/api/method/ash7anly.mobile_api.get_balance?   sid=
  "message": {
        "balance": 9864.33,
        "user": "505632750@ash7anly.sa"
    }
   */
  Future<String> getCurrentBalance(String sid) async {
    Loader.showUnDismissibleLoader(context);

    /// todo endpoint
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(
        "https://app.rasseed.com/api/method/ash7anly.mobile_api.get_balance?"));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode({"sid": sid})));
    HttpClientResponse response = await request.close();

    print("\n\n status code is: ${response.statusCode}\n\n");

    // todo - you should check the response.statusCode
    String replay = await response.transform(utf8.decoder).join();
    httpClient.close();
    print("\n\n replay: ${replay}\n\n");

    if (response.statusCode == 200) {
      Loader.hideDialog(context);
      print('\n\nbody is: ${json.decode(replay)['message']}\n\n');
      print(
          '\n\n json.decode(replay)[message] is: ${json.decode(replay)['message']}\n\n');
      print(
          '\n\n json.decode(replay)[message][balance] is: ${json.decode(replay)['message']['balance']}\n\n');
      setState(() => currentBalance =
          json.decode(replay)['message']['balance'] != null
              ? json.decode(replay)['message']['balance'].toString()
              : '0.0');
      addValueToShared(key: 'userBalance', value: currentBalance);
    } else {
      Loader.hideDialog(context);
    }
  }

  /*https://app.rasseed.com/api/method/ash7anly.mobile_api.get_point?   sid=
  "message":"0"
   */
  Future<String> getUserPoints(String sid) async {
    Loader.showUnDismissibleLoader(context);

    /// todo endpoint
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(
        "https://app.rasseed.com/api/method/ash7anly.mobile_api.get_point?"));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode({"sid": sid})));
    HttpClientResponse response = await request.close();

    print("\n\n status code is: ${response.statusCode}\n\n");

    // todo - you should check the response.statusCode
    String replay = await response.transform(utf8.decoder).join();
    httpClient.close();
    print("\n\n replay: ${replay}\n\n");

    if (response.statusCode == 200) {
      Loader.hideDialog(context);
      print(
          '\n\n getUserPoints body is: ${json.decode(replay)['message']}\n\n');
      setState(() => userPoints = json.decode(replay)['message'] != null
          ? json.decode(replay)['message'].toString()
          : '0.0');
    } else {
      Loader.hideDialog(context);
    }
  }

  void addValueToShared({String key, String value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  void openWhatsApp() async {
    if (await canLaunch("https://api.whatsapp.com/send?phone=966566521112")) {
      await launch("https://api.whatsapp.com/send?phone=966566521112");
    } else {
      throw 'Could not launch https://api.whatsapp.com/send?phone=966566521112';
    }
  }

  @override
  void initState() {
    super.initState();
    getUserSID().then((savedSID) {
      getCurrentBalance(savedSID);
      getUserPoints(savedSID);
    });

    getClientName().then((savedClientName) => setState(() =>
        savedClientName != null
            ? clientName = savedClientName
            : clientName = null));
    getClientPhone().then((savedClientPhone) => setState(() =>
        savedClientPhone != null
            ? clientPhone = savedClientPhone
            : clientPhone = null));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: profileScaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(69, 57, 137, 1.0),
                ),
//                height: MediaQuery.of(context).size.height/5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                                icon: Icon(
                                  Icons.exit_to_app,
                                  color: Colors.white,
                                  size: 20.0,
                                ),
                                onPressed: () {
                                  logoutUser();
                                }),
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
                      ),
                    ),
                    Container(
//                      margin: EdgeInsets.only(top: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: 15.0, left: 50.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  // add user name
                                  '${clientName ?? ''}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  // add user phone
                                  '${clientPhone ?? ''}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          Container(
//                            margin: EdgeInsets.only(right: 80.0),
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 2.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40.0))),
                            child: Icon(
                              Icons.account_circle,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20.0, bottom: 40.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          InvitationPoints(userPoints)));
                            },
                            child:Container(
                            padding: EdgeInsets.only(
                                left: 15, right: 15, top: 4, bottom: 4.0),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              border: Border.all(
                                  color: Color.fromRGBO(190, 169, 226, 1.0)),
                              color: Color.fromRGBO(77, 67, 125, 1.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    "نقاط دعوتك",
                                    style: TextStyle(
                                        color:
                                            Color.fromRGBO(190, 169, 226, 1.0),
                                        fontSize: 20.0),
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(right: 3.0),
                                        child: Text(
                                          "نقطه",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 12),
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                          // user points
                                          "${userPoints ?? 0.00}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 32,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20.0, right: 20.0),
                            color: Colors.grey.withOpacity(.5),
                            width: .5,
                            height: 65.0,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          AccountStatement(currentBalance)));
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 15, right: 15, top: 4, bottom: 4.0),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                border: Border.all(
                                    color: Color.fromRGBO(190, 169, 226, 1.0)),
                                color: Color.fromRGBO(77, 67, 125, 1.0),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      "الرصيد الحالى",
                                      style: TextStyle(
                                          color: Color.fromRGBO(
                                              190, 169, 226, 1.0),
                                          fontSize: 19.0),
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(right: 3.0),
                                          child: Text(
                                            "ريال",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 12),
                                          ),
                                        ),
                                        Text(
                                          "  ",
                                        ),
                                        Container(
                                          child: Text(
                                            // add current balance
                                            "${currentBalance ?? 0.00}",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 32,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new Invite_friends()));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(left: 20.0, top: 7.0),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                            size: 20.0,
                          )),
                      Container(
                        margin: EdgeInsets.only(right: 20.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Text(
                                "دعوة صديق",
                                style: TextStyle(
                                    color: Color.fromRGBO(69, 57, 137, 1.0),
                                    fontSize: 20),
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.only(left: 20.0, top: 0.0),
                                child: Icon(
                                  Icons.person_add,
                                  color: Color.fromRGBO(69, 57, 137, 1.0),
                                  size: 30.0,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10.0),
                width: MediaQuery.of(context).size.width,
                height: .5,
                color: Colors.grey.withOpacity(.5),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) => new My_cards()));
                },
                child: Container(
                  margin: EdgeInsets.only(top: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(left: 20.0, top: 7.0),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                            size: 20.0,
                          )),
                      Container(
                        margin: EdgeInsets.only(right: 20.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Text(
                                "البطاقات",
                                style: TextStyle(
                                    color: Color.fromRGBO(69, 57, 137, 1.0),
                                    fontSize: 20),
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.only(left: 20.0, top: 0.0),
                                child: Icon(
                                  Icons.credit_card,
                                  color: Color.fromRGBO(69, 57, 137, 1.0),
                                  size: 30.0,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
//              Container(
//                margin: EdgeInsets.only(top: 10.0),
//                width: MediaQuery.of(context).size.width,
//                height: .5,
//                color: Colors.grey.withOpacity(.5),
//              ),
//              GestureDetector(
//                onTap: () {
//                  Navigator.push(
//                      context,
//                      new MaterialPageRoute(
//                          builder: (BuildContext context) =>
//                              new PaymentMethod()));
//                },
//                child: Container(
//                  margin: EdgeInsets.only(top: 15.0),
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: <Widget>[
//                      Container(
//                          margin: EdgeInsets.only(left: 20.0, top: 7.0),
//                          child: Icon(
//                            Icons.arrow_back_ios,
//                            color: Colors.black,
//                            size: 20.0,
//                          )),
//                      Container(
//                        margin: EdgeInsets.only(right: 20.0),
//                        child: Row(
//                          crossAxisAlignment: CrossAxisAlignment.start,
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          children: <Widget>[
//                            Container(
//                              child: Text(
//                                "الدفع",
//                                style: TextStyle(
//                                    color: Color.fromRGBO(69, 57, 137, 1.0),
//                                    fontSize: 20),
//                              ),
//                            ),
//                            Container(
//                                margin: EdgeInsets.only(left: 20.0, top: 0.0),
//                                child: Icon(
//                                  Icons.credit_card,
//                                  color: Color.fromRGBO(69, 57, 137, 1.0),
//                                  size: 30.0,
//                                )),
//                          ],
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
//              ),
              Container(
                margin: EdgeInsets.only(top: 10.0),
                width: MediaQuery.of(context).size.width,
                height: .5,
                color: Colors.grey.withOpacity(.5),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new ArchiveOperations()));
                },
                child: Container(
                  margin: EdgeInsets.only(top: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(left: 20.0, top: 7.0),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                            size: 20.0,
                          )),
                      Container(
                        margin: EdgeInsets.only(right: 20.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Text(
                                "سجل العمليات",
                                style: TextStyle(
                                    color: Color.fromRGBO(69, 57, 137, 1.0),
                                    fontSize: 20),
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.only(left: 20.0, top: 0.0),
                                child: Icon(
                                  Icons.history,
                                  color: Color.fromRGBO(69, 57, 137, 1.0),
                                  size: 30.0,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10.0),
                width: MediaQuery.of(context).size.width,
                height: .5,
                color: Colors.grey.withOpacity(.5),
              ),
              GestureDetector(
                onTap: () {
                  openWhatsApp();
                },
                child: Container(
                  margin: EdgeInsets.only(top: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(left: 20.0, top: 7.0),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                            size: 20.0,
                          )),
                      Container(
                        margin: EdgeInsets.only(right: 20.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Text(
                                "مساعده",
                                style: TextStyle(
                                    color: Color.fromRGBO(69, 57, 137, 1.0),
                                    fontSize: 20),
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.only(left: 20.0, top: 0.0),
                                child: Icon(
                                  Icons.help_outline,
                                  color: Color.fromRGBO(69, 57, 137, 1.0),
                                  size: 30.0,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10.0),
                width: MediaQuery.of(context).size.width,
                height: .5,
                color: Colors.grey.withOpacity(.5),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) => new Setting()));
                },
                child: Container(
                  margin: EdgeInsets.only(top: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(left: 20.0, top: 7.0),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                            size: 20.0,
                          )),
                      Container(
                        margin: EdgeInsets.only(right: 20.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Text(
                                "الإعدادات",
                                style: TextStyle(
                                    color: Color.fromRGBO(69, 57, 137, 1.0),
                                    fontSize: 20),
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.only(left: 20.0, top: 0.0),
                                child: Icon(
                                  Icons.settings,
                                  color: Color.fromRGBO(69, 57, 137, 1.0),
                                  size: 30.0,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10.0),
                width: MediaQuery.of(context).size.width,
                height: .5,
                color: Colors.grey.withOpacity(.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
