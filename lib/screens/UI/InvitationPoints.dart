import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:rasseed/utils/center_loader.dart';
import 'package:rasseed/utils/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InvitationPoints extends StatefulWidget {
  InvitationPoints(this.userPoints);

  final String userPoints;

  @override
  _InvitationPointsState createState() => _InvitationPointsState();
}

class _InvitationPointsState extends State<InvitationPoints> {
  GlobalKey<ScaffoldState> invitationPointsGlobalKey = GlobalKey();

  String transactionStatus; // = 'owing';  = 'deduct';
  String owing = 'owing';
  String deduct = 'deduct';

  List<dynamic> userBalanceSheetList = List();
//  List<dynamic> userBalanceCardsList;

  userRecipeWidget(List<dynamic> cardsList) {
    return GridView.builder(
        itemCount: cardsList.length,
        physics: NeverScrollableScrollPhysics(),
        primary: false,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 5.0, crossAxisSpacing: 5.0),
        itemBuilder: (context, index) {
          return Container(
            height: MediaQuery.of(context).size.height / 10,
            margin: EdgeInsets.only(left: 10.0, right: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Card(
              elevation: 8.0,
              child: Column(
//                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
//                    width: MediaQuery.of(context).size.width / 4,
                    height: MediaQuery.of(context).size.height / 8,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          Uri.encodeFull(
                              "https://www.rasseed.com${cardsList[index]['logo']}"),
                        ),
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              "رس",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(width: 2,),
                            Text(
                              '${cardsList[index]['value']}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              'بطاقه',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(width: 2,),
                            Text(
                              '${cardsList[index]['quantity']}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  /*
https://app.rasseed.com/api/method/ash7anly.api.balance_sheet?
      "message": [
        {
            "purchase_order_data": {
                "archive_date": null,
                "archived": 0,
                "name": "b6fff46154",
                "creation": "2019-12-28 12:42:14.868031",
                "cards": [
                    {
                        "name": "04d655a4d3",
                        "parent": "b6fff46154",
                        "value": 21.0,
                        "printer_logo": "/files/Webp.net-compress-image.jpg",
                        "logo": "/files/stc.png",
                        "card": "STC Recharge 21 Card",
                        "quantity": 1
                    }
                ],
                "owner": "505632750@ash7anly.sa",
                "order_status": "open"
            },
            "creation": "2019-12-28 12:42:16.125142",
            "purchase_order": "b6fff46154",
            "user": "505632750@ash7anly.sa",
            "transaction_status": "deduct",
            "total_paid": 21.0
        },
      ]
   */

  Future<bool> getUserRecipe(String sid) async {
    Loader.showUnDismissibleLoader(context);

    /// todo endpoint
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(
        "https://app.rasseed.com/api/method/ash7anly.api.balance_sheet"));
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
      print('\n\n getUserRecipe body is: ${json.decode(replay)['message']}\n\n');
      setState(() => userBalanceSheetList = json.decode(replay)['message']);
      return true;
    } else {
      Loader.hideDialog(context);
      setState(() {
        userBalanceSheetList = List();
      });
      return false;
    }
  }

  Future<bool> convertUserPoints(String sid) async {
    Loader.showUnDismissibleLoader(context);

    /// todo endpoint
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(
        "https://www.rasseed.com/api/method/ash7anly.mobile_api.convert_point_to_balance"));
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
          '\n\n getUserRecipe body is: ${json.decode(replay)['message']}\n\n');
//      setState(() => userPoints = json.decode(replay)['message']);

      invitationPointsGlobalKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            '${json.decode(replay)['message']}',
            textAlign: TextAlign.center,
          )));

      return true;
    } else {
      Loader.hideDialog(context);
      invitationPointsGlobalKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            '${json.decode(replay)['message']}',
            textAlign: TextAlign.center,
          )));
      return false;
    }
  }

  Future<String> getUserSID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('\n\n\n user sid: ${prefs.getString('client_auth')}\n\n\n');
    return prefs.getString('client_auth');
  }

  @override
  void initState() {
    super.initState();
    getUserSID().then((savedSID) {
      getUserRecipe(savedSID).then((returnCardStatus) {
        if (returnCardStatus == false) {
          Navigator.pop(context);
          invitationPointsGlobalKey.currentState.showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'حدثت مشكلة اثناء جلب البيانات برجاء المحاولة لاحقا!',
              textAlign: TextAlign.center,
            ),
          ));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Color.fromRGBO(69, 57, 137, 1.0));
    return Scaffold(
      key: invitationPointsGlobalKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color.fromRGBO(69, 57, 137, 1.0),
        centerTitle: true,
        title: Text(
          "نقاطك",
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.close,
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
        child: Container(
//          color: Colors.grey.withOpacity(.2),
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 4,
                color: Color.fromRGBO(69, 57, 137, 1.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "نقطه",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        Text(
                          " "
                          "${widget.userPoints ?? '0.00'}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Text(
                        "يمكنك تحويل نقاطك الي رصيد",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontSize: 14),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              getUserSID().then((savedSID) {
                                convertUserPoints(savedSID);
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.all(10.0),
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(69, 57, 137, 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                border: Border.all(color: Colors.white),
                              ),
                              width: MediaQuery.of(context).size.width / 2,
                              child: Text(
                                "تحويل",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.only(top: 15.0, left: 12.0, right: 12.0),
                child: Text(
                  "العملاء",
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
              ),
              Container(
                child: Container(
                  padding: EdgeInsets.all(30),
                  height: MediaQuery.of(context).size.height / 1.2,
                  child: userBalanceSheetList != null
                      ? userBalanceSheetList.length > 0
                          ? ListView.builder(
                              itemCount: userBalanceSheetList.length,
                              primary: true,
                              shrinkWrap: false,
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).size.height / 4),
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(top: 15.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                                margin: EdgeInsets.only(
                                                    left: 20.0, top: 7.0),
                                                child: Text(
                                                  '${userBalanceSheetList[index]['transaction_status'] == deduct ? '-' : '+'}'
                                                  '${userBalanceSheetList[index]['total_paid'] ?? ''}',
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      color: userBalanceSheetList[
                                                                      index][
                                                                  'transaction_status'] ==
                                                              deduct
                                                          ? Colors.red
                                                              .withOpacity(1.0)
                                                          : Colors.green
                                                              .withOpacity(1.0),
                                                      fontWeight:
                                                          FontWeight.w400),
                                                )),
                                            Container(
                                              margin:
                                                  EdgeInsets.only(right: 20.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: <Widget>[
                                                  Container(
                                                    child: Text(
                                                      '${userBalanceSheetList[index]['user'] ?? ''}',
                                                      style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              69, 57, 137, 1.0),
                                                          fontSize: 15),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        right: 10.0),
                                                    child: Text(
                                                      'التاريخ: '
                                                      '${userBalanceSheetList[index]['creation'] != null ? userBalanceSheetList[index]['creation'].toString().substring(0, 10) : 'غير معروف'}',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      userBalanceSheetList[index]
                                              ['purchase_order_data'] is List
                                          ? Container()
                                          : Container(
                                              margin:
                                                  EdgeInsets.only(top: 20.0),
//                              height: userBalanceSheetList[index]
//                              ['purchase_order_data']['cards']
//                                  .length %
//                                  2 ==
//                                  0
//                                  ? ((userBalanceSheetList[index]
//                              ['purchase_order_data']['cards']
//                                  .length /
//                                  2) *
//                                  (MediaQuery.of(context)
//                                      .size
//                                      .height /
//                                      3.2))
//                                  : (userBalanceSheetList[index]['purchase_order_data']['cards']
//                                  .length *
//                                  (MediaQuery.of(context)
//                                      .size
//                                      .height /
//                                      3.2)),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: userRecipeWidget(
                                                  userBalanceSheetList[index][
                                                          'purchase_order_data']
                                                      ['cards'])),
                                      Container(
                                        margin: EdgeInsets.only(top: 10.0),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: .5,
                                        color: Colors.grey.withOpacity(.5),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          : Container(
                              child: Text(
                                '!لا يوجد لديك عملاء حتي الان',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 16),
                              ),
                            )
                      : CenterCircularLoader(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
