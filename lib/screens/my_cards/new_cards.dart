import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rasseed/screens/Home_screen.dart';
import 'package:rasseed/screens/UI/AccountStatment.dart';
import 'package:rasseed/screens/my_cards/ShopCard.dart';
import 'package:rasseed/utils/center_loader.dart';
import 'package:rasseed/utils/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class new_cards extends StatefulWidget {
  @override
  _new_cardsState createState() => _new_cardsState();
}

class _new_cardsState extends State<new_cards> {
  List<Map<String, dynamic>> cardsDataList;

  /// "https://app.rasseed.com/api/method/ash7anly.api.operators_card_store?sid=get_the_value_from_activate"
/*
"message": [
        {
            "instruction_1": "Enter from left to right, Then Press call",
            "instruction_2_b": "#",
            "name": "a302034c3a",
            "parent": null,
            "is_web_card": 0,
            "is_active": 0,
            "shortcut": "STC",
            "instruction_2_ar_a": "*155*",
            "priority": 1,
            "instruction_2_a": "*155*",
            "instruction_1_ar": " أدخل من اليسار إلى اليمين ثم اضغط اتصال ",
            "printer_logo": "/files/Webp.net-compress-image.jpg",
            "operator": "الاتصالات السعودية - سوا",
            "logo": "/files/stc.png",
            "disactive_logo": "/files/stc 2018-06-25 22:29:17.png",
            "app_version": "21",
            "cards": [
                {
                    "category": "SAR 10",
                    "count_card": 0,
                    "name": "Card00001",
                    "parent": "a302034c3a",
                    "mycredits_used": 0.0,
                    "mycredits": 0.0,
                    "value": 10.0,
                    "category_unit": null,
                    "min_price": null,
                    "ordered_date": "1919-12-25 23:40:38",
                    "price_t4": 10.0,
                    "price_t2": 9.8,
                    "price_t3": 9.9,
                    "card": "STC Recharge 10 Card"
                },
            ],
            "col": 2,
            "instruction_2_ar_b": "#",
            "row": 0
        }
    ]


{
    "message": [
        {
            "instruction_1": "Enter from left to right",
            "pin": null,
            "mycredits_used": 0,
            "creation": "2020-01-06 01:31:59.565156",
            "is_multiple": false,
            "instruction_1_ar": " أدخل من اليسار إلى اليمي ثم اضغط اتصال ",
            "charged_to": null,
            "total_paid": 20.0,
            "logo": "/files/m1.png",
            "serial": null,
            "namecard": "Card00150",
            "category": "SAR 20",
            "printer_logo": "/files/mobily.jpg",
            "charge_date": null,
            "instruction_2_ar_a": "*1400*",
            "instruction_2_ar_b": "*رقم الهوية#",
            "uncharge_count": 1,
            "charge_time": "01:31 AM",
            "mycredits": 1,
            "user": "510922408@ash7anly.sa",
            "price_t4": 19.9,
            "price_t2": 19.6,
            "price_t3": 19.7,
            "card": "Mobily Recharge 20 Card",
            "number_message_sent": 0,
            "name": "659b8a9d62",
            "validto": null,
            "value": 20.0,
            "instruction_2_a": "*1400*",
            "scrape_id": null,
            "instruction_2_b": "*ID Number# then ok or dial "
        }
    ]
}
 */
  Future<String> getUserSID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('\n\n\n user sid: ${prefs.getString('client_auth')}\n\n\n');
    return await prefs.getString('client_auth');
  }
  Future<String> getUserBalance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('\n\n\n userBalance: ${prefs.getString('userBalance')}\n\n\n');
    return await prefs.getString('userBalance');
  }

  Future<String> getNewCards(String sid) async {
    cardsDataList = List();
    Loader.showUnDismissibleLoader(context);

    /// todo endpoint
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(
       "https://app.rasseed.com/api/method/ash7anly.api.flutter_operators_card_store?"
    ));

    request.headers.set('content-type', 'application/json');

    request.add(utf8.encode(json.encode({"sid": sid})));
    print("BBBBBBBB ${request}");
    HttpClientResponse response = await request.close();

    print("\n\n status code is: ${response.statusCode}\n\n");

    // todo - you should check the response.statusCode
    String replay = await response.transform(utf8.decoder).join();
    httpClient.close();
    print("\n\n replay: ${replay}\n\n");

    if (response.statusCode == 200) {
      Loader.hideDialog(context);

      setState(() {
        print('\n\nbody is: ${json.decode(replay)['message']}\n\n');
        if(json.decode(replay)['message'] != null)
          json.decode(replay)['message'].forEach((cardData) => setState(() {
          cardsDataList.add(cardData);
        }));
      });
    } else {
      Loader.hideDialog(context);
      // error
    }

    print('\n\ncard list length: ${cardsDataList.length}\n\n');
  }

  showNoBalanceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        content: Container(
          height: MediaQuery.of(context).size.height / 4.5,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 15.0),
                child: Text(
                  "ليس لديك رصيد كافي لشراء كرت جديد",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15.0),
                child: Text(
                  "هل تريد الشحن؟",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 40.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> AccountStatement('0.0')));
                        },
                        child: Text(
                          "إيداع رصيد",
                          style: TextStyle(
                              fontSize: 16,
                              color: Color.fromRGBO(69, 57, 137, 1.0),
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),
                    Container(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "اغلاق",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
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

  @override
  void initState() {
    super.initState();
    getUserBalance().then((savedBalance){

      if(double.parse(savedBalance) == 0.0){
        setState(() {cardsDataList = List();
//        showNoBalanceDialog();
        });
      }else

        getUserSID().then((savedSID) => getNewCards(savedSID));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          cardsDataList != null
              ?
          cardsDataList.length > 0
              ? Container(
            alignment: Alignment.topRight,
            height: MediaQuery
                .of(context)
                .size
                .height / 1.27,
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: ListView.builder(
                itemCount: cardsDataList.length,
                primary: true,
                shrinkWrap: false,
                padding: EdgeInsets.all(10.0),
                itemBuilder: (context, index) {
//                  List<dynamic> cardsList = cardsDataList[index]['cards'];
                  return Container(
                    child: cardsDataList != null? GridView.builder(
                        itemCount: 1,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        primary: false,
                        padding: EdgeInsets.all(10.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 8,
                            crossAxisCount: 2,
                            crossAxisSpacing: 8),
                        itemBuilder: (context, innerIndex) {
                          return GestureDetector(
                            onTap: () =>
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ShopCard(cardsDataList[index], isNewCard:true))),
                            child: Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.centerRight,
                                    width: MediaQuery.of(context).size.width / 4,
                                    height: MediaQuery.of(context).size.height / 9,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          Uri.encodeFull(
                                              "https://www.rasseed.com${cardsDataList[index]['logo']}"),
                                        ),
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(12)),
                                    ),
                                  ),
                                  Container(

//                                  height: MediaQuery.of(context).size.height / 15 ,
                                    alignment: Alignment.bottomCenter,
                                    padding: EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
//                                    color: Color.fromRGBO(69, 57, 137, 1.0)
//                                        .withOpacity(0.6),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(12),
                                        bottomRight: Radius.circular(12),
                                      ),
                                    ),
//                                  margin: EdgeInsets.only(left: 20.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          '${cardsDataList[index]['value']}',
                                          textAlign:TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
//                                          backgroundColor:
//                                          Color.fromRGBO(69, 57, 137, 1.0)
//                                              .withOpacity(0.3),
                                              fontWeight: FontWeight.w300,
                                              fontSize: 15),
                                        ),

                                        Container(
                                          width: MediaQuery.of(context).size.width / 4,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: <Widget>[
                                              Text(
                                                'رقم البطاقه',
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Text(
                                                '|||||||||||||||||||||',
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }):Container(),
                  );
//                        return GestureDetector(
//                            onTap: () => Navigator.push(
//                                context,
//                                MaterialPageRoute(
//                                    builder: (context) =>
//                                        ShopCard(cardsDataList[index]))),
//                            child: Container(
//                              margin: EdgeInsets.all(10.0),
//                              decoration: BoxDecoration(
//                                image: DecorationImage(
//                                  image: NetworkImage(
//                                    Uri.encodeFull(
//                                        "https://www.rasseed.com${cardsDataList[index]['logo']}"),
//                                  ),
//                                ),
//                                borderRadius:
//                                    BorderRadius.all(Radius.circular(12)),
//                              ),
//                              child: Container(
//                                margin: EdgeInsets.only(left: 20.0),
//                                alignment: Alignment.bottomLeft,
//                                child: Text(
//                                  '${cardsDataList[index]['value']}',
//                                  style: TextStyle(
//                                      color: Colors.white,
//                                      backgroundColor:
//                                          Color.fromRGBO(69, 57, 137, 1.0)
//                                              .withOpacity(0.3),
//                                      fontWeight: FontWeight.w300,
//                                      fontSize: 15),
//                                ),
//                              ),
//                            ),
//                          );
                }),
          )
              : Container(
            height: MediaQuery.of(context).size.height / 1.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Text("لا يوجد لديك بطاقات جديدة "),
                ),
                InkWell(
                  onTap: ()=> Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Home_screen())),
                  child: Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width / 4,
                    height: 50,
                    child: Center(child: Text("شراء بطاقات")),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromRGBO(69, 57, 137, 1.0)),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                )
              ],
            ),
          )
              :Container(
            height: MediaQuery.of(context).size.height / 1.5,
           ),
        ],
      ),
    );
  }
}

/// before update API
/*
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rasseed/screens/UI/AccountStatment.dart';
import 'package:rasseed/screens/my_cards/ShopCard.dart';
import 'package:rasseed/utils/center_loader.dart';
import 'package:rasseed/utils/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class new_cards extends StatefulWidget {
  @override
  _new_cardsState createState() => _new_cardsState();
}

class _new_cardsState extends State<new_cards> {
  List<Map<String, dynamic>> cardsDataList;

  /// "https://app.rasseed.com/api/method/ash7anly.api.operators_card_store?sid=get_the_value_from_activate"
*/
/*
"message": [
        {
            "instruction_1": "Enter from left to right, Then Press call",
            "instruction_2_b": "#",
            "name": "a302034c3a",
            "parent": null,
            "is_web_card": 0,
            "is_active": 0,
            "shortcut": "STC",
            "instruction_2_ar_a": "*155*",
            "priority": 1,
            "instruction_2_a": "*155*",
            "instruction_1_ar": " أدخل من اليسار إلى اليمين ثم اضغط اتصال ",
            "printer_logo": "/files/Webp.net-compress-image.jpg",
            "operator": "الاتصالات السعودية - سوا",
            "logo": "/files/stc.png",
            "disactive_logo": "/files/stc 2018-06-25 22:29:17.png",
            "app_version": "21",
            "cards": [
                {
                    "category": "SAR 10",
                    "count_card": 0,
                    "name": "Card00001",
                    "parent": "a302034c3a",
                    "mycredits_used": 0.0,
                    "mycredits": 0.0,
                    "value": 10.0,
                    "category_unit": null,
                    "min_price": null,
                    "ordered_date": "1919-12-25 23:40:38",
                    "price_t4": 10.0,
                    "price_t2": 9.8,
                    "price_t3": 9.9,
                    "card": "STC Recharge 10 Card"
                },
            ],
            "col": 2,
            "instruction_2_ar_b": "#",
            "row": 0
        }
    ]
 *//*

  Future<String> getUserSID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('\n\n\n user sid: ${prefs.getString('client_auth')}\n\n\n');
    return await prefs.getString('client_auth');
  }
  Future<String> getUserBalance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('\n\n\n userBalance: ${prefs.getString('userBalance')}\n\n\n');
    return await prefs.getString('userBalance');
  }

  Future<String> getNewCards(String sid) async {
    cardsDataList = List();
    Loader.showUnDismissibleLoader(context);

    /// todo endpoint
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(
//       "https://app.rasseed.com/api/method/ash7anly.api.flutter_operators_card_store?"
     "https://app.rasseed.com/api/method/ash7anly.api.operators_card_store?"
    ));

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

      setState(() {
        print('\n\nbody is: ${json.decode(replay)['message']}\n\n');
        json
            .decode(replay)['message']
            .forEach((cardData) => setState(() {
          cardsDataList.add(cardData);
        }));
      });
    } else {
      Loader.hideDialog(context);
      // error
    }

    print('\n\ncard list length: ${cardsDataList.length}\n\n');
  }

  showNoBalanceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        content: Container(
          height: MediaQuery.of(context).size.height / 4.5,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 15.0),
                child: Text(
                  "ليس لديك رصيد كافي لشراء كرت جديد",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15.0),
                child: Text(
                  "هل تريد الشحن؟",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 40.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> AccountStatement('0.0')));
                        },
                        child: Text(
                          "إيداع رصيد",
                          style: TextStyle(
                              fontSize: 16,
                              color: Color.fromRGBO(69, 57, 137, 1.0),
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),
                    Container(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "اغلاق",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
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

  @override
  void initState() {
    super.initState();
    getUserBalance().then((savedBalance){

      if(double.parse(savedBalance) == 0.0){
        setState(() {cardsDataList = List();
        showNoBalanceDialog();
        });
      }else

        getUserSID().then((savedSID) => getNewCards(savedSID));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          cardsDataList != null
              ?
          cardsDataList.length > 0
              ? Container(
            alignment: Alignment.topRight,
            height: MediaQuery
                .of(context)
                .size
                .height / 1.27,
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: ListView.builder(
                itemCount: cardsDataList.length,
                primary: true,
                shrinkWrap: false,
                padding: EdgeInsets.all(10.0),
                itemBuilder: (context, index) {
                  List<dynamic> cardsList = cardsDataList[index]['cards'];
                  return Container(
                    child: cardsList != null? GridView.builder(
                        itemCount: cardsList.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        primary: false,
                        padding: EdgeInsets.all(10.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 8,
                            crossAxisCount: 2,
                            crossAxisSpacing: 8),
                        itemBuilder: (context, innerIndex) {
                          return GestureDetector(
                            onTap: () =>
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ShopCard(cardsDataList[index], innerIndex:innerIndex))),
                            child: Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.centerRight,
                                    width: MediaQuery.of(context).size.width / 4,
                                    height: MediaQuery.of(context).size.height / 9,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          Uri.encodeFull(
                                              "https://www.rasseed.com${cardsDataList[index]['logo']}"),
                                        ),
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(12)),
                                    ),
                                  ),
                                  Container(

//                                  height: MediaQuery.of(context).size.height / 15 ,
                                    alignment: Alignment.bottomCenter,
                                    padding: EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
//                                    color: Color.fromRGBO(69, 57, 137, 1.0)
//                                        .withOpacity(0.6),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(12),
                                        bottomRight: Radius.circular(12),
                                      ),
                                    ),
//                                  margin: EdgeInsets.only(left: 20.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          '${cardsList[innerIndex]['value']}',
                                          textAlign:TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
//                                          backgroundColor:
//                                          Color.fromRGBO(69, 57, 137, 1.0)
//                                              .withOpacity(0.3),
                                              fontWeight: FontWeight.w300,
                                              fontSize: 15),
                                        ),

                                        Container(
                                          width: MediaQuery.of(context).size.width / 4,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: <Widget>[
                                              Text(
                                                'رقم البطاقه',
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Text(
                                                '|||||||||||||||||||||',
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }):Container(),
                  );
//                        return GestureDetector(
//                            onTap: () => Navigator.push(
//                                context,
//                                MaterialPageRoute(
//                                    builder: (context) =>
//                                        ShopCard(cardsDataList[index]))),
//                            child: Container(
//                              margin: EdgeInsets.all(10.0),
//                              decoration: BoxDecoration(
//                                image: DecorationImage(
//                                  image: NetworkImage(
//                                    Uri.encodeFull(
//                                        "https://www.rasseed.com${cardsDataList[index]['logo']}"),
//                                  ),
//                                ),
//                                borderRadius:
//                                    BorderRadius.all(Radius.circular(12)),
//                              ),
//                              child: Container(
//                                margin: EdgeInsets.only(left: 20.0),
//                                alignment: Alignment.bottomLeft,
//                                child: Text(
//                                  '${cardsDataList[index]['value']}',
//                                  style: TextStyle(
//                                      color: Colors.white,
//                                      backgroundColor:
//                                          Color.fromRGBO(69, 57, 137, 1.0)
//                                              .withOpacity(0.3),
//                                      fontWeight: FontWeight.w300,
//                                      fontSize: 15),
//                                ),
//                              ),
//                            ),
//                          );
                }),
          )
              : Container(
            height: MediaQuery.of(context).size.height / 1.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Text("لا يوجد لديك بطاقات جديدة "),
                ),
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width / 4,
                  height: 50,
                  child: Center(child: Text("شراء بطاقات")),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Color.fromRGBO(69, 57, 137, 1.0)),
                      borderRadius: BorderRadius.circular(10)),
                )
              ],
            ),
          )
              :CenterCircularLoader(),
        ],
      ),
    );
  }
}
*/
