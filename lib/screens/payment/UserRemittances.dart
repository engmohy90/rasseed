import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:rasseed/utils/center_loader.dart';
import 'package:rasseed/utils/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// todo update ui with mohy image
class UserRemittances extends StatefulWidget {
  @override
  _UserRemittancesState createState() => _UserRemittancesState();
}

class _UserRemittancesState extends State<UserRemittances> {
  List<RemittancesModel> remittancesModelList = List();

  GlobalKey<ScaffoldState> userRemittanceScaffoldKey = GlobalKey();

  /// https://app.rasseed.com/api/method/ash7anly.api.bank_status?sid=6e33ff8dc79453bab0ea246be828e6f8b85dbaf8dbe93c580622b8c0
  //

  Future<String> getUserSID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('\n\n\n user sid: ${prefs.getString('client_auth')}\n\n\n');
    return prefs.getString('client_auth');
  }

  Future<dynamic> getUserRemittances(String sid) async {
    Loader.showUnDismissibleLoader(context);

    /// todo endpoint
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(
        "https://app.rasseed.com/api/method/ash7anly.api.bank_status?"));
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

      List<dynamic> messageList = json.decode(replay)['message'];
      return messageList;
    } else {
      Loader.hideDialog(context);
      return null;
    }
  }

  @override
  void initState() {
    super.initState();

    getUserSID().then((savedSID) {
      getUserRemittances(savedSID).then((apiRemittanceList) {
        print(
            '\n\n remittance list length: ${remittancesModelList.length}\n\n');
        apiRemittanceList != null && apiRemittanceList is List
            ? setState(() {
                apiRemittanceList.forEach((item) {
                  remittancesModelList.add(RemittancesModel.fromJson(item));
                });
              })
            : userRemittanceScaffoldKey.currentState.showSnackBar(SnackBar(
                backgroundColor: Colors.red,
                content: Text('حدث خطأ فى الاتصال بالانترنت!')));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Color.fromRGBO(69, 57, 137, 1.0));
    return Scaffold(
      key: userRemittanceScaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color.fromRGBO(69, 57, 137, 1.0),
        centerTitle: true,
        title: Text(
          "حالة الحوالات البنكيه",
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
        ),
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
        leading: Container(
          color: Color.fromRGBO(69, 57, 137, 1.0),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 15.0, left: 12.0, right: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "ارشفة لجميع حركات التحويلات البنكية بحسابك",
                    style: TextStyle(
                        color: Color.fromRGBO(69, 57, 137, 1.0), fontSize: 15),
                  ),
                  Text(
                    "في رصيد",
                    style: TextStyle(
                        color: Color.fromRGBO(69, 57, 137, 1.0), fontSize: 15),
                  )
                ],
              ),
            ),
            remittancesModelList != null
                ? remittancesModelList.length > 0
                    ? ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: remittancesModelList != null
                            ? remittancesModelList.length : 0,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 15.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: 20.0, top: 7.0),
                                      child: Text(
                                        '${remittancesModelList[index].amount??''}',
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.red.withOpacity(1.0),
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(right: 20.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          Container(
                                            child: Text(
                                              '${remittancesModelList[index].user??''}',
                                              style: TextStyle(
                                                color: Color.fromRGBO(69, 57, 137, 1.0),
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              '${remittancesModelList[index].creation??''}',
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      69, 57, 137, 1.0),
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // todo the
                                    Container(
                                      margin: EdgeInsets.only(right: 20.0),
                                      child: Icon(Icons.refresh),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10.0),
                                width: MediaQuery.of(context).size.width,
                                height: .5,
                                color: Colors.grey.withOpacity(.5),
                              ),
                            ],
                          );
                        },
                      )
                    : Container(
                        height: MediaQuery.of(context).size.height / 1.5,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text("لا يوجد بيانات لعرضها"),
                        ),
                      )
                : Container(
                    child: Center(child: CenterCircularLoader()),
                  ),
          ],
        ),
      ),
    );
  }
}

class RemittancesModel {
  final String status;
  final String creation;
  final double amount;
  final dynamic user;
  final String fullName;
  final String bank;
  final String accountNumber;

  /*

{
"status": "cancelled",
"creation": "2019-12-11 14:00:32.101085",
"amount": 250,
"user": null,
"fullname": "basma 555 test",
"bank": "SAMBA Financial Group",
"account_number": "2588774555"
},

   */
  RemittancesModel({
    this.status,
    this.creation,
    this.amount,
    this.user,
    this.fullName,
    this.bank,
    this.accountNumber,
  });

  factory RemittancesModel.fromJson(dynamic json) => RemittancesModel(
        status: json['status'],
        creation: json['creation'],
        amount: json['amount'],
        user: json['user'],
        fullName: json['fullname'],
        bank: json['bank'],
        accountNumber: json['account_number'],
      );
}
