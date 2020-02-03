import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as prefix0;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rasseed/screens/my_cards/SendCard.dart';
import 'package:rasseed/screens/my_cards/TransferCard.dart';
import 'package:rasseed/screens/my_cards/my_cards.dart';
import 'package:rasseed/screens/settings/Profile.dart';
import 'package:rasseed/utils/custom_circle_avatar.dart';
import 'package:rasseed/utils/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopCard extends StatefulWidget {
  ShopCard(this.cardsData, {this.isNewCard});

  final Map<String, dynamic> cardsData;
  final bool isNewCard;

  @override
  _ShopCardState createState() => _ShopCardState();
}

/*

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
                }
 */
/*
  {
            "instruction_1": "Enter from left to right",
            "pin": "16689644361517826",
            "mycredits_used": 1,
            "creation": "2019-12-19 11:35:13.102664",
            "is_multiple": false,
            "instruction_1_ar": " أدخل من اليسار إلى اليمي ثم اضغط اتصال ",
            "charged_to": "510922408",
            "total_paid": 60.0,
            "logo": "/files/m1.png",
            "serial": "190503899035",
            "namecard": "Card00167",
            "category": "15 SAR",
            "printer_logo": "/files/mobily.jpg",
            "pins": "\"16689644361517826\"",
            "charge_date": "2019-12-19",
            "instruction_2_ar_a": "*1400*",
            "instruction_2_ar_b": "*رقم الهوية#",
            "charge_time": "11:35 AM",
            "mycredits": 3,
            "scrape_count": 1,
            "user": "510922408@ash7anly.sa",
            "price_t4": 14.93,
            "price_t2": 14.7,
            "price_t3": 14.78,
            "card": "Mobily Recharge 15 Card",
            "number_message_sent": 0,
            "name": "c3299fbd0b",
            "validto": "2021-11-25",
            "value": 15.0,
            "instruction_2_a": "*1400*",
            "scrape_id": "3IwzthZUwF",
            "instruction_2_b": "*ID Number# then ok or dial "
        },
   */
class _ShopCardState extends State<ShopCard> {
  bool isExpanded = false;
  bool isSending = false;
  int scrappingCardsNumber;
  int returningCardsNumber;

  Map<String, dynamic> card;

  GlobalKey<ScaffoldState> shopCartGlobalKey = GlobalKey();
  TextEditingController phoneController = TextEditingController();

  bool displayError = false;

  scrappingAlert(StateSetter setter) {
    setter(() {
      scrappingCardsNumber = 1;
      displayError = false;
    });
    showDialog(
      context: context,
      builder: (context) =>
          StatefulBuilder(builder: (BuildContext context, StateSetter state) {
        return AlertDialog(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          content: Container(
            height: displayError ? MediaQuery.of(context).size.height / 3 : MediaQuery.of(context).size.height / 4,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 15.0),
                  child: Text(
                    "عدد الكروت التى تريد كشطها",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: Container(
                      margin: EdgeInsets.only(left: 5.0, right: 5.0),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              if (scrappingCardsNumber < card['mycredits'])
                                state(() {
                                  scrappingCardsNumber = scrappingCardsNumber + 1;
                                  print('\n\n;lkjhgfcghjkl; $scrappingCardsNumber\n\n');
                                });
                              else
                                state(() {
                                  displayError = true;
                                });
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(.7),
                                  shape: BoxShape.circle),
                              child: Center(
                                child: Text(
                                  "+",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            child: Text(
                              scrappingCardsNumber.toString(),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (scrappingCardsNumber > 1) {
                                state(() {
                                  displayError = false;
                                  scrappingCardsNumber = scrappingCardsNumber - 1;
                                  print('\n\n;lkjhgfcghjkl; $scrappingCardsNumber\n\n');
                                });
                              } else
                                state(() {
                                  displayError = false;
                                });
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(.7),
                                  shape: BoxShape.circle),
                              child: Center(
                                child: Text(
                                  "-",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),

                // ignore: sdk_version_ui_as_code
                if (displayError)
                  Container(
                    child: Text(
                      'غير مسموح بكشط عدد اكبر من عدد بطاقاتك',
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
                          onTap: () => getUserSID().then((savedSID) =>
                              getUserPhone().then(

                                  /// todo display a loader and an alert for any action
                                  (savedPhone) => scrapCard(
                                              savedSID,
                                              card['namecard'],
                                              scrappingCardsNumber,
                                              savedPhone)
                                          .then((scrapCardStatus) {
                                        if (scrapCardStatus) {
                                          shopCartGlobalKey.currentState
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                              'تم كشط الكارت بنجاح',
                                              textAlign: TextAlign.center,
                                            ),
                                          ));
                                          Timer(
                                              Duration(milliseconds: 500),
                                              () => Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          My_cards())));
                                        } else {
                                          Navigator.pop(context);

                                          shopCartGlobalKey.currentState
                                              .showSnackBar(SnackBar(
                                            backgroundColor: Colors.red,
                                            content: Text(
                                              'حدثت مشكلة اثناء كشط الكارت برجاء المحاولة لاحقا!',
                                              textAlign: TextAlign.center,
                                            ),
                                          ));
                                        }
                                      }))),
                          child: Text(
                            "كشط",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.green,
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
                                color: Color.fromRGBO(69, 57, 137, 1.0),
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
        );
      }),
    );
  }
  returningAlert(StateSetter setter) {
    setter(() {
      returningCardsNumber = 1;
      displayError = false;
    });
    showDialog(
      context: context,
      builder: (context) =>
          StatefulBuilder(builder: (BuildContext context, StateSetter state) {
        return AlertDialog(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),

          content: Container(
            height: displayError ? MediaQuery.of(context).size.height / 3 : MediaQuery.of(context).size.height / 4,
            width:
            MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 15.0),
                  child: Text(
                      ':عدد الكروت المراد إعادتها',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: Container(
                      margin: EdgeInsets.only(
                          left: 5.0, right: 5.0),
                      alignment:
                      Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment
                            .center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              if (returningCardsNumber <
                                  card[
                                  'mycredits']) {
                                returningCardsNumber =
                                    returningCardsNumber +
                                        1;
                                print(
                                    '\n\n  returningCardsNumber; $returningCardsNumber\n\n');
                              } else
                                state(() {
                                  displayError = true;
                                });
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Colors
                                      .grey
                                      .withOpacity(
                                      .7),
                                  shape: BoxShape
                                      .circle),
                              child: Center(
                                child: Text(
                                  "+",
                                  style: TextStyle(
                                      color: Colors
                                          .white),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            child: Text(
                              returningCardsNumber.toString(),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (returningCardsNumber >
                                  1) {
                                state(() {
                                  displayError =
                                  false;
                                  returningCardsNumber =
                                      returningCardsNumber -
                                          1;
                                  print(
                                      '\n\n  returningCardsNumber; $returningCardsNumber\n\n');
                                });
                              }else
                                state(() {
                                  displayError = false;
                                });
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Colors
                                      .grey
                                      .withOpacity(
                                      .7),
                                  shape: BoxShape
                                      .circle),
                              child: Center(
                                child: Text(
                                  "-",
                                  style:
                                  TextStyle(
                                    color: Colors
                                        .white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                // ignore: sdk_version_ui_as_code
                if (displayError)
                  Container(
                    child: Text(
                      'غير مسموح باعادة عدد اكبر من عدد بطاقاتك',
                    ),
                  ),
                Container(
                  width: MediaQuery.of(context)
                      .size
                      .width,
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment
                        .spaceEvenly,
                    children: <Widget>[
                      InkWell(
                        child: Text('إعادة',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.green,
                              fontWeight: FontWeight.normal),),
                        onTap: () => getUserSID()
                            .then((savedSID) =>
                            getUserPhone().then(
                                    (savedPhone) => /// todo add returnCardsNumber
                                    returnCard(
                                      savedSID,
                                      card[
                                      'namecard'],
                                      savedPhone,
                                    ).then(
                                            (returnCardStatus) {
                                          if (returnCardStatus) {
                                            shopCartGlobalKey
                                                .currentState
                                                .showSnackBar(SnackBar(
                                              content:
                                              Text(
                                                'تم إعادة الكارت بنجاح',
                                                textAlign: TextAlign.center,
                                              ),
                                            ));
                                            Timer(
                                                Duration(seconds: 1),
                                                    () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Profile())));
                                          } else {
                                            Navigator.pop(
                                                context);

                                            shopCartGlobalKey
                                                .currentState
                                                .showSnackBar(SnackBar(
                                              content:
                                              Text(
                                                'حدثت مشكلة اثناء إعادة الكارت برجاء المحاولة لاحقا!',
                                                textAlign: TextAlign.center,
                                              ),
                                            ));
                                          }
                                        }))),
                      ),
                      InkWell(
                        child: Text('الغاء'),
                        onTap: () =>
                            Navigator.pop(
                                context),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

//  sendingAlert(StateSetter setter) {
//    showDialog(
//      context: context,
//      builder: (context) => StatefulBuilder(
//        builder: (BuildContext context, StateSetter state) => AlertDialog(
//          elevation: 4.0,
//          shape: RoundedRectangleBorder(
//              borderRadius: BorderRadius.all(Radius.circular(10.0))),
//          content: Container(
//            alignment: Alignment.center,
//            height: MediaQuery.of(context).size.height / 3,
//            child: Container(
//              height: (MediaQuery.of(context).size.height / 100) * 40,
//              child: Column(
//                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                children: <Widget>[
//                  Text('ارسال الكارت'),
//                  TextField(
//                    controller: phoneController,
//                    autofocus: false,
//                    textAlign: TextAlign.center,
//                    focusNode: FocusNode(),
//                    style: TextStyle(fontSize: 14),
//                    maxLines: 1,
//                    keyboardType: TextInputType.phone,
//                    decoration: InputDecoration(
//                      hintText: "ادخل رقم الجوال المراد الارسال اليه",
////                        border: InputBorder.none,
//                    ),
//                  ),
//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                    children: <Widget>[
//                      InkWell(
//                        child: Text('إرسال'),
//                        onTap: () {
//                          RegExp exp = new RegExp(r"(^[5]\d{8})");
//                          String str = phoneController.text;
//                          bool phone_exp = exp.hasMatch(str);
//
//                          if (phone_exp == false)
//                            shopCartGlobalKey.currentState
//                                .showSnackBar(SnackBar(
//                              backgroundColor: Colors.red,
//                              content: Text(
//                                'رقم الهاتف يجب أن يكون 9 أرقام ويبدأ برقم 5، مثال: 598765432',
//                                textAlign: TextAlign.center,
//                              ),
//                            ));
//                          else
//                            getUserSID().then((savedSID) {
//                              sendCard(
//                                      sid: savedSID,
//                                      pin: card['pin'],
//                                      phone: phoneController.text)
//                                  .then((sendingCardStatus) {
//                                print(
//                                    '\n\nbody is phoneController.text: ${phoneController.text}\n\n');
//                                print('\n\nbody is pin: ${card['pin']}\n\n');
//                                if (sendingCardStatus) {
//                                  shopCartGlobalKey.currentState
//                                      .showSnackBar(SnackBar(
//                                    content: Text(
//                                      'تم إسال الكارت بنجاح',
//                                      textAlign: TextAlign.center,
//                                    ),
//                                  ));
//                                  Timer(Duration(seconds: 2), () {
//                                    Navigator.pop(context);
//                                    Navigator.pop(context);
//                                    Navigator.pushReplacement(
//                                        context,
//                                        MaterialPageRoute(
//                                            builder: (context) => My_cards()));
//                                  });
//                                } else {
//                                  Navigator.pop(context);
//
//                                  shopCartGlobalKey.currentState
//                                      .showSnackBar(SnackBar(
//                                    backgroundColor: Colors.red,
//                                    content: Text(
//                                      'حدثت مشكلة اثناء إرسال الكارت برجاء المحاولة مرة اخرى!',
//                                      textAlign: TextAlign.center,
//                                    ),
//                                  ));
//                                }
//                              });
//                            });
//                        },
//                      ),
//                      InkWell(
//                        child: Text('الغاء'),
//                        onTap: () => Navigator.pop(context),
//                      )
//                    ],
//                  ),
//                ],
//              ),
//            ),
//          ),
//        ),
//      ),
//    );
//  }

  Future<String> getUserSID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString('client_auth');
  }

  Future<String> getUserPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString('phone');
  }

  Future<bool> returnCard(
    String sid,
    String nameCard,
    String userPhone,
  ) async {
    print("\n\n sode is: phone: $userPhone  , card: $nameCard, sid: $sid\n\n");

    Loader.showUnDismissibleLoader(context);
//phone=555001233&card=Card00001&sid=b2256680c91fe0b026a5183359f7e8199795c1f5eb16cabba022ad33
    /// todo endpoint
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(
        "https://www.rasseed.com/api/method/ash7anly.api.return_card?"));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode({
      "phone": userPhone,
      "card": nameCard,
      "sid": sid,
    })));
    HttpClientResponse response = await request.close();

    print("\n\n status code is: ${response.statusCode}\n\n");

    // todo - you should check the response.statusCode
    String replay = await response.transform(utf8.decoder).join();
    httpClient.close();
    print("\n\n replay: ${replay}\n\n");

    if (response.statusCode == 200) {
      Loader.hideDialog(context);
      print('\n\nbody is: ${json.decode(replay)['message']}\n\n');
//      json.decode(replay)['message'].forEach((cardData){
//        cardsDataList.add(cardData);
//      });
      return true;
    } else {
      Loader.hideDialog(context);
      // error
      return false;
    }
  }

  Future<String> transferCard(
    String sid,
    String nameCard,
  ) async {
    Loader.showUnDismissibleLoader(context);

    /// todo endpoint
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(
        Uri.parse("https://www.rasseed.com/api/resource/resource/Transfer"));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode({
      /// todo add dynamic data
      "data": {
        "from_user": "555001233",
        "to_user": "555001233",
        "transfer_details": [
          {"quantity": 1, "card": "Card00001"}
        ]
      },
      "sid": sid,
    })));
    HttpClientResponse response = await request.close();

    print("\n\n status code is: ${response.statusCode}\n\n");

    // todo - you should check the response.statusCode
    String replay = await response.transform(utf8.decoder).join();
    httpClient.close();
    print("\n\n replay: ${replay}\n\n");

    if (response.statusCode == 200) {
      Loader.hideDialog(context);
      print('\n\nbody is: ${json.decode(replay)['message']}\n\n');
//      json.decode(replay)['message'].forEach((cardData){
//        cardsDataList.add(cardData);
//      });
    } else {
      Loader.hideDialog(context);
      // error
    }
  }

//  Future<bool> sendCard({
//    String sid,
//    String phone,
//    String pin,
//  }) async {
//    Loader.showUnDismissibleLoader(shopCartGlobalKey.currentContext);
//
//    /// todo endpoint
//    /// https://app.rasseed.com/api/method/ash7anly.api.resend_sms_pin_code?
//    /// sid=39620135c3f577347fc9ca35f347da33fed63923a92ea537b71c39af
//    /// &phone=505632750
//    /// &pin=1234567
//
//    print("\n\n status code sid: $sid\n\n");
//    print("\n\n status code pin: $pin\n\n");
//    print("\n\n status code phone: $phone\n\n");
//
//    HttpClient httpClient = new HttpClient();
//    HttpClientRequest request = await httpClient.postUrl(Uri.parse(
//        "https://app.rasseed.com/api/method/ash7anly.api.resend_sms_pin_code?"));
//    request.headers.set('content-type', 'application/json');
//    request.add(utf8.encode(json.encode({
//      "sid": sid,
//      "phone": phone,
//      "pin": pin,
//    })));
//    HttpClientResponse response = await request.close();
//    print("\n\n status code is: ${response.statusCode}\n\n");
//
//    // todo - you should check the response.statusCode
//    String replay = await response.transform(utf8.decoder).join();
//    httpClient.close();
//    print("\n\n replay: ${replay}\n\n");
//
//    if (response.statusCode == 200) {
//      Loader.hideDialog(context);
//      print('\n\nbody is: ${json.decode(replay)['message']}\n\n');
////      json.decode(replay)['message'].forEach((cardData){
////        cardsDataList.add(cardData);
////      });
//      return true;
//    } else {
//      Loader.hideDialog(context);
//      // error
//      return false;
//    }
//  }

/*
single card
/api/method/ash7anly.api.scrape_card_fixed?phone=505632750&card=Card00001&sid=dfe5f56a3719c1b57c1f45a89dfefad5d9b3fb90cdc1dcaa53b637dc

multi cards
/api/method/ash7anly.api.bulk_scrape_cards?number_card_scrape=4&card=Card00002&sid=dfe5f56a3719c1b57c1f45a89dfefad5d9b3fb90cdc1dcaa53b637dc

 */
  Future<bool> scrapCard(
    String sid,
    String nameCard,
    int cardsNumber,
    String userPhone,
  ) async {
    Loader.showUnDismissibleLoader(context);

    print('\n\n scrap sid : $sid \n\n');
    print('\n\n scrap nameCard : $nameCard \n\n');
    print('\n\n scrap userPhone : $userPhone \n\n');

    /// todo endpoint
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = cardsNumber > 1
        ? await httpClient.postUrl(Uri.parse(
            "https://www.rasseed.com/api/method/ash7anly.api.bulk_scrape_cards?"))
        : await httpClient.postUrl(Uri.parse(
            "https://www.rasseed.com/api/method/ash7anly.api.scrape_card_fixed?"));
    request.headers.set('content-type', 'application/json');
    cardsNumber > 1
        ? request.add(utf8.encode(json.encode({
            "number_card_scrape": cardsNumber,
            "card": nameCard,
            "sid": sid,
          })))
        : request.add(utf8.encode(json.encode({
            "phone": userPhone,
            "card": nameCard,
            "sid": sid,
          })));
    HttpClientResponse response = await request.close();

    print("\n\n status code is: ${response.statusCode}\n\n");

    // todo - you should check the response.statusCode
    String replay = await response.transform(utf8.decoder).join();
    httpClient.close();
    print("\n\n replay: ${replay}\n\n");

    if (response.statusCode == 200) {
      Loader.hideDialog(context);
      print('\n\nbody is: ${json.decode(replay)['message']}\n\n');
//      json.decode(replay)['message'].forEach((cardData){
//        cardsDataList.add(cardData);
//      });
      return true;
    } else {
      Loader.hideDialog(context);
      shopCartGlobalKey.currentState.showSnackBar(SnackBar(
        content: Text('Failed to scrap this card!'),
      ));
      return false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      card =
          /* widget.innerIndex != null
          ? widget.cardsData['cards'][widget.innerIndex]
          :*/
          widget.cardsData;

      print('\n\ncardcardcard : $card\n\n');
      print('\n\n widget.cardsDatawidget.cardsData : ${widget.cardsData}\n\n');
    });
  }

  @override
  Widget build(BuildContext context) {
//    var childButtons = List<UnicornButton>();

//    childButtons.add(UnicornButton(
//        hasLabel: true,
//        labelText: "Choo choo",
//        currentButton: FloatingActionButton(
//          onPressed: () {
//            print('\n\n\n button clicked kjsghjskala;kdjvbmn\n\n');
//          },
//          heroTag: "train",
//          backgroundColor: Colors.white,
//          mini: true,
//          child: Icon(
//            Icons.send,
//            color: Color.fromRGBO(69, 57, 137, 1.0),
//          ),
//        )));
//    childButtons.add(UnicornButton(
//        currentButton: FloatingActionButton(
//      onPressed: () {
//        print('\n\n\n button clicked kjsghjskala;kdjvbmn\n\n');
//      },
//      heroTag: "airplane",
//      backgroundColor: Colors.white,
//      mini: true,
//      child: Icon(
//        Icons.credit_card,
//        color: Color.fromRGBO(69, 57, 137, 1.0),
//      ),
//    )));
//    childButtons.add(UnicornButton(
//        currentButton: FloatingActionButton(
//      heroTag: "directions",
//      backgroundColor: Colors.white,
//      mini: true,
//      child: Icon(
//        Icons.transform,
//        color: Color.fromRGBO(69, 57, 137, 1.0),
//      ),
//      onPressed: () {
//        print('\n\n\n button clicked kjsghjskala;kdjvbmn\n\n');
//      },
//    )));
//    childButtons.add(UnicornButton(
//        currentButton: FloatingActionButton(
//      onPressed: () {
//        print('\n\n\n button clicked kjsghjskala;kdjvbmn\n\n');
//      },
//      heroTag: "directionss",
//      backgroundColor: Colors.white,
//      mini: true,
//      child: Icon(
//        Icons.repeat,
//        color: Color.fromRGBO(69, 57, 137, 1.0),
//      ),
//    )));

    return Scaffold(
      key: shopCartGlobalKey,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(69, 57, 137, 1.0),
        centerTitle: true,
        title: Text(
          '${card['card'] ?? 'بطاقة متجر'}',
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
                Navigator.of(context).pop();
              }),
        ],
        leading: Container(
          color: Color.fromRGBO(69, 57, 137, 1.0),
        ),
        elevation: 0.0,
      ),
//      floatingActionButton: UnicornDialer(
//          backgroundColor: Color.fromRGBO(255, 255, 255, 0.6),
//          parentButtonBackground: Colors.redAccent,
//          orientation: UnicornOrientation.HORIZONTAL,
//          parentButton: Icon(Icons.more_vert),
//          childButtons: childButtons),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => isExpanded = !isExpanded),
        child: isExpanded
            ? Icon(
                Icons.close,
                color: Colors.white,
              )
            : Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              margin: EdgeInsets.only(left: 15.0, top: 25.0, right: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              Uri.encodeFull(
                                  "https://www.rasseed.com${widget.cardsData['logo']}"),
                            ),
                          ),
//                            borderRadius: BorderRadius.all(Radius.circular(12.0),),

                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.height / 4,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height / 15,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
//                            Text(
//                              '${card['card'] ?? ''}',
//                              style: TextStyle(
//                                color: Color.fromRGBO(69, 57, 137, 1.0),
//                                fontWeight: FontWeight.w900,
//                                fontSize: 16.0,
//                              ),
//                            ),
                            Text(
                              '${card['value'] ?? '0 رس'}',
                              style: TextStyle(
                                  color: Color.fromRGBO(69, 57, 137, 1.0),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
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
                                    '${card['pin'] ?? '|||||||||||||||||||||'}',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
//                      Chip(
//                        label: Text(
//                          '${card['card'] ?? ''}',
//                          style: TextStyle(
//                            color: Colors.white,
////                          backgroundColor: Color.fromRGBO(69, 57, 137, 1.0)
////                              .withOpacity(0.3),
//                            fontWeight: FontWeight.w900,
//                            fontSize: 16.0,
//                          ),
//                        ),
//                        avatar: Text(
//                          '${card['value'] ?? '0 رس'}',
//                          style: TextStyle(
//                              color: Colors.white,
//                              fontSize: 14,
//                              fontWeight: FontWeight.w400),
//                        ),
//                      ),
//                      Container(
//                        alignment: Alignment.topRight,
//                        margin: EdgeInsets.only(
//                            top: 10.0, right: 10.0, left: 10.0),
//                        child: Text(
//                          '${card['card'] ?? ''}',
//                          style: TextStyle(
//                            color: Colors.white,
//                            backgroundColor: Color.fromRGBO(69, 57, 137, 1.0)
//                                .withOpacity(0.3),
//                            fontWeight: FontWeight.w900,
//                            fontSize: 16.0,
//                          ),
//                        ),
//                      ),
//                      Container(
//                        child: Row(
//                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                          crossAxisAlignment: CrossAxisAlignment.start,
//                          children: <Widget>[
//                            Container(
//                              alignment: Alignment.bottomLeft,
//                              margin:
//                              EdgeInsets.only(left: 15.0, right: 15.0),
//                              child: Text(
//                                '${card['value'] ?? '0 رس'}',
//                                style: TextStyle(
//                                    color: Colors.white,
//                                    backgroundColor:
//                                    Color.fromRGBO(69, 57, 137, 1.0)
//                                        .withOpacity(0.3),
//                                    fontSize: 14,
//                                    fontWeight: FontWeight.w400),
//                              ),
//                            ),
//                            Container(
//                              alignment: Alignment.bottomLeft,
//                              margin:
//                              EdgeInsets.only(left: 15.0, right: 15.0),
//                              child: Text(
//                                '${card['pin'] ?? 'رقم البطاقه'}',
//                                style: TextStyle(
//                                    color: Colors.white,
//                                    backgroundColor:
//                                    Color.fromRGBO(69, 57, 137, 1.0)
//                                        .withOpacity(0.3),
//                                    fontSize: 14,
//                                    fontWeight: FontWeight.w400),
//                              ),
//                            ),
//                          ],
//                        ),
//                      ),
                    ],
                  ),
//                  Container(
//                    decoration: BoxDecoration(
//                        image: DecorationImage(
//                          image: NetworkImage(
//                            Uri.encodeFull(
//                                "https://www.rasseed.com${widget.cardsData['logo']}"),
//                          ),
//                        ),
//                        borderRadius: BorderRadius.all(Radius.circular(12.0))),
//                    margin: EdgeInsets.only(top: 25.0, left: 15.0, right: 15.0),
//                    width: MediaQuery.of(context).size.width,
//                    height: MediaQuery.of(context).size.height / 4,
//                    child: Column(
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                      children: <Widget>[
//                        Container(
//                          alignment: Alignment.topRight,
//                          margin: EdgeInsets.only(
//                              top: 10.0, right: 10.0, left: 10.0),
//                          child: Text(
//                            '${card['card'] ?? ''}',
//                            style: TextStyle(
//                              color: Colors.white,
//                              backgroundColor: Color.fromRGBO(69, 57, 137, 1.0)
//                                  .withOpacity(0.3),
//                              fontWeight: FontWeight.w900,
//                              fontSize: 16.0,
//                            ),
//                          ),
//                        ),
//                        Container(
//                          child: Row(
//                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: <Widget>[
//                              Container(
//                                alignment: Alignment.bottomLeft,
//                                margin:
//                                    EdgeInsets.only(left: 15.0, right: 15.0),
//                                child: Text(
//                                  '${card['value'] ?? '0 رس'}',
//                                  style: TextStyle(
//                                      color: Colors.white,
//                                      backgroundColor:
//                                          Color.fromRGBO(69, 57, 137, 1.0)
//                                              .withOpacity(0.3),
//                                      fontSize: 14,
//                                      fontWeight: FontWeight.w400),
//                                ),
//                              ),
//                              Container(
//                                alignment: Alignment.bottomLeft,
//                                margin:
//                                    EdgeInsets.only(left: 15.0, right: 15.0),
//                                child: Text(
//                                  '${card['pin'] ?? 'رقم البطاقه'}',
//                                  style: TextStyle(
//                                      color: Colors.white,
//                                      backgroundColor:
//                                          Color.fromRGBO(69, 57, 137, 1.0)
//                                              .withOpacity(0.3),
//                                      fontSize: 14,
//                                      fontWeight: FontWeight.w400),
//                                ),
//                              ),
//                            ],
//                          ),
//                        ),
//                      ],
//                    ),
//                  ),
                  widget.isNewCard
                      ? Container(
                          margin: EdgeInsets.only(
                              left: 15.0, right: 15.0, top: 10.0),
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            padding: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(69, 57, 137, .2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: Text(
                              'بطاقه جديده',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15.0,
                                  color: Color.fromRGBO(69, 57, 137, 1.0)),
                            ),
                          ),
                        )
                      : Container(),
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 10.0, left: 5.0),
                          height: 130.0,
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: Card(
                            elevation: 5.0,
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      'البطاقات المستخدمه',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      '${card['mycredits_used'] ?? '0'}',
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(69, 57, 137, 1.0),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10.0, right: 5.0),
                          height: 130.0,
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: Card(
                            elevation: 5.0,
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      'بطاقاتى',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      '${card['mycredits'] ?? '0'}',
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(69, 57, 137, 1.0),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ],
                              ),
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
              height: MediaQuery.of(context).size.height - 100,
              child: BackdropFilter(
                filter: prefix0.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: isExpanded
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.bottomCenter,
                            height: MediaQuery.of(context).size.height / 3,
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      isExpanded = false;
                                    });
                                    return Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SendCard(card)));
                                  },
                                  //sendingAlert(shopCartGlobalKey.currentState.setState),
                                  child: ClipOval(
                                    clipper: CircleClipper(),
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.width / 6,
                                      height:
                                          MediaQuery.of(context).size.width / 6,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            width: 2,
                                            color:
                                                Colors.grey.withOpacity(0.3)),
                                      ),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                5,
                                        height:
                                            MediaQuery.of(context).size.width /
                                                5,
                                        padding: EdgeInsets.all(5.0),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(
                                                Icons.send,
                                                color: Color.fromRGBO(
                                                    69, 57, 137, 1.0),
                                                size: 20.0,
                                              ),
                                              Text('ارسال'),
                                            ]),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: ()=> returningAlert(shopCartGlobalKey.currentState.setState),
                                  child: ClipOval(
                                    clipper: CircleClipper(),
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.width / 6,
                                      height:
                                          MediaQuery.of(context).size.width / 6,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            width: 2,
                                            color:
                                                Colors.grey.withOpacity(0.3)),
                                      ),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                5,
                                        height:
                                            MediaQuery.of(context).size.width /
                                                5,
                                        padding: EdgeInsets.all(5.0),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(
                                                Icons.keyboard_return,
                                                color: Color.fromRGBO(
                                                    69, 57, 137, 1.0),
                                                size: 20.0,
                                              ),
                                              Text('إعادة'),
                                            ]),
                                      ),
                                    ),
                                  ),
                                ),

                                /// if cards used disappear Transfer
                                widget.isNewCard
                                    ? InkWell(
                                        onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TransferCard(card))),
                                        child: ClipOval(
                                          clipper: CircleClipper(),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                6,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                6,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  width: 2,
                                                  color: Colors.grey
                                                      .withOpacity(0.3)),
                                            ),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  5,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  5,
                                              padding: EdgeInsets.all(5.0),
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.repeat,
                                                      color: Color.fromRGBO(
                                                          69, 57, 137, 1.0),
                                                      size: 20.0,
                                                    ),
                                                    Text('تحويل'),
                                                  ]),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),

                                /// if cards used disappear scrap
                                widget.isNewCard
                                    ? InkWell(
                                        onTap: () => scrappingAlert(
                                            shopCartGlobalKey
                                                .currentState.setState),
                                        child: ClipOval(
                                          clipper: CircleClipper(),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                6,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                6,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  width: 2,
                                                  color: Colors.grey
                                                      .withOpacity(0.3)),
                                            ),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  5,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  5,
                                              padding: EdgeInsets.all(5.0),
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.credit_card,
                                                      color: Color.fromRGBO(
                                                          69, 57, 137, 1.0),
                                                      size: 20.0,
                                                    ),
                                                    Text('كشط'),
                                                  ]),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          )
                        ],
                      )
                    : Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
