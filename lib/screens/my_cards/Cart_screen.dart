import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rasseed/functions/shared_services.dart';
import 'package:rasseed/screens/my_cards/GET_CURRENT_URL.dart';
import 'package:rasseed/screens/my_cards/my_cards.dart';
import 'package:rasseed/screens/payment/PaymentMethod.dart';
import 'package:rasseed/utils/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Cart_screen extends StatefulWidget {
  @override
  _Cart_screenState createState() => _Cart_screenState();
}

class _Cart_screenState extends State<Cart_screen> {
  double num = 0;

  double totalPrice = 0.0;

  List<String> userCardsList;

  String paymentMethod;

  dynamic removedCard;

  GlobalKey<ScaffoldState> cartScreenKey = GlobalKey();

  String currentBalance = '0';

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
          '\n\n json.decode(replay)[message] is: ${json.decode(
              replay)['message']}\n\n');
      print(
          '\n\n json.decode(replay)[message][balance] is: ${json.decode(
              replay)['message']['balance']}\n\n');
      setState(() =>
      currentBalance =
      json.decode(replay)['message']['balance'] != null
          ? json.decode(replay)['message']['balance'].toString()
          : '0.0');
    } else {
      Loader.hideDialog(context);
    }
  }

  Future<String> buyFromMyAccount(String sid) async {
    Loader.showUnDismissibleLoader(context);
    List<Map> apiList = List();

    userCardsList.forEach((item) {
      print("\n\n item userCardsList    : $item\n\n");
      apiList.add(
          {
            "quantity": json.decode(item)['apiObjectCount'],
            "card": json.decode(json.decode(item)['apiObject'])['name']
          }
      );
    });

    apiList.forEach((item) {
      print("\n\n item itemitem    : $item\n\n");
    });

    print("\n\n item fufgbnmhu    : ${jsonEncode({
      "order_status": "open",
      "is_bank": 1,
      "order_details": apiList
    })}\n\n");
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(
        Uri.parse("https://app.rasseed.com/api/resource/Purchase%20Orders"));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode({
      "data": jsonEncode(
          {"order_status": "open", "is_bank": 1, "order_details": apiList}),
      //"{\"order_status\":\"open\",\"is_bank\":\"1\",\"order_details\":[{\"quantity\":1,\"card\":\"Card00120\"}]}",//${jsonEncode(apiList)}",
      "sid": sid
    })));
//    request.add(utf8.encode(json.encode({
//      "data":
//          "{\"order_status\":\"open\",\"is_bank\":\"1\",\"order_details\":[{\"quantity\":1,\"card\":\"Card00002\"}]}",
//      "sid": "64fc4904519bfe16e91ca4c277fc54fc4de1a4006847176fa76aee13"
//    })));
    HttpClientResponse response = await request.close();
    String replay = await response.transform(utf8.decoder).join();
    httpClient.close();
    print("\n\n replay: $replay\n\n");

    print("\n\n response.statusCode: ${response.statusCode}\n\n");

    if (response.statusCode == 200) {
      final body = json.decode(replay);

      removeListFromShared().then((dummy) {
        Loader.hideDialog(context);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => My_cards()));
      });
    } else {
      Loader.hideDialog(context);
      cartScreenKey.currentState
          .showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'فشل عمليه الشراء',
            textAlign: TextAlign.center,
          )));
    }

    return "done";
  }
  openApplePayUi() async {
    const url = 'https://www.rasseed.com/ar/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  Future<String> buy() async {
    Loader.showUnDismissibleLoader(context);
    print("buy&&&&buy");

    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(
        Uri.parse("https://app.rasseed.com/api/resource/Purchase%20Orders"));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode({
      "data":
      "{\"order_status\":\"open\",\"is_visa\":\"1\",\"order_details\":[{\"quantity\":1,\"card\":\"Card00002\"}]}",
      "sid": "64fc4904519bfe16e91ca4c277fc54fc4de1a4006847176fa76aee13"
    })));
    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    String replay = await response.transform(utf8.decoder).join();
    httpClient.close();
    print("${replay}dssaaadxxsd");

    print("ggggg${response.statusCode}");

    if (response.statusCode == 200) {
      final body = json.decode(replay);
      print(body["data"]["signature"]);
      String signature = body["data"]["signature"];

      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) =>
              GetCurrentURLWebView(
//            title: "Payment",
                selectedUrl: "https://app.rasseed.com/payfort_visa?signature=" +
                    signature,
              )));
    } else {
//        message_error_controoler.text = json.decode(replay)['message'];
      Loader.hideDialog(context);
    }

    return "done";
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
      getCurrentBalance(savedSID);
    });
    getListFromShared().then((savedList) {
      print('\n\nsaved list: $savedList\n\n');
      print('\n\nsaved list.length: ${savedList.length}\n\n');
      setState(() => userCardsList = savedList);

      ///
      ///
      ///
      ///
      savedList.forEach((savedCard) {
        print('\n\nsaved card: $savedCard\n\n');
        print(
            '\n\nsaved json.decod ,n,: ${json.decode(
                savedCard)['apiObject']}\n\n');
        print(
            '\n\nsaved json.decod ,n,apiObjectCount: ${json.decode(
                savedCard)['apiObjectCount']}\n\n');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    getTotalPrice().then((savedTotalPrice) =>
        setState(() => totalPrice = savedTotalPrice ?? 0.0));
    getPaymentMethodName().then((savedPaymentMethod) =>
        setState(() => paymentMethod = savedPaymentMethod ?? ''));
    return Scaffold(
      key: cartScreenKey,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: GestureDetector(
          onTap: () {
            //Signup(name, password, address, email);
          },
          child: Container(
              color: Colors.white,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 5, top: 5),
                    child: GestureDetector(
                      onTap: () {

                        getPaymentMethodName().then((paymentName) {

                          if(paymentName == null){
                            cartScreenKey.currentState
                                .showSnackBar(SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(
                                  'يجب اخيار طريقه الدفع اولا',
                                  textAlign: TextAlign.center,
                                )));
                          }
                          else if(paymentName == 'رصيدي'){
                            double.parse(currentBalance) >= totalPrice ?
                            getUserSID().then((savedSID) {
                              buyFromMyAccount(savedSID);
                            }): cartScreenKey.currentState
                                .showSnackBar(SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(
                                  'ليس لديك رصيد كافي!',
                                  textAlign: TextAlign.center,
                                )));
                          }

                          else if(paymentName == 'ابل باى'){
                            openApplePayUi();
                          }
                          else {
                            buy();
                          }


                        });

                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue[700],
                            borderRadius:
                            new BorderRadius.all(Radius.circular(10))),
                        width: MediaQuery
                            .of(context)
                            .size
                            .width / 2,
                        child: Center(
                          child: Text(
                            "شراء",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Container(child: Text("المجموع")),
                          Row(
                            children: <Widget>[
                              Container(child: Text('رس')),
                              Container(child: Text('   ')),
                              Container(child: Text("$totalPrice")),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ))),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: MediaQuery
              .of(context)
              .size
              .height,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Color.fromRGBO(69, 57, 137, 1.0),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),

              /// todo removed
//              Padding(
//                padding: const EdgeInsets.only(left: 20, right: 20),
//                child: Container(
//                  alignment: Alignment.topRight,
//                  height: 30,
//                  width: MediaQuery.of(context).size.width,
//                  decoration: BoxDecoration(
//                      borderRadius: BorderRadius.circular(10),
//                      color: Color.fromRGBO(69, 57, 137, 1.0).withOpacity(.2),
//                      border:
//                          Border.all(color: Color.fromRGBO(69, 57, 137, 1.0))),
//                  child: Row(
//                    crossAxisAlignment: CrossAxisAlignment.end,
//                    mainAxisAlignment: MainAxisAlignment.end,
//                    children: <Widget>[
//                      /// todo adding user account
//                      Text("رصيد حسابك 0.00 ر س"),
//                      Padding(
//                        padding: const EdgeInsets.only(right: 10),
//                        child: Icon(Icons.monetization_on),
//                      ),
//                    ],
//                  ),
//                ),
//              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Container(
                    alignment: Alignment.topRight,
                    child: Text(
                      "مشترياتك",
                      style: TextStyle(fontSize: 24),
                    )),
              ),
              userCardsList != null
                  ? userCardsList.length > 0
                  ? Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height / 2.5,

                  /// todo edit user saved cards
                  child: ListView.builder(
                      itemCount: userCardsList != null
                          ? userCardsList.length
                          : 0,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          height:
                          MediaQuery
                              .of(context)
                              .size
                              .height / 9,
                          child: Slidable(
                            actionPane: SlidableDrawerActionPane(),
                            actionExtentRatio: 0.17,
                            closeOnScroll: true,
                            actions: <Widget>[
                              GestureDetector(
                                onTap: () =>
                                    showDialog(
                                        context: context,
                                        builder: (context) =>
                                            AlertDialog(
                                              content: ListTile(
                                                title: Text("عملية الحذف"),
                                                subtitle: Text(
                                                    "هل تريد حذف هذا العنصر"),
                                              ),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text('نعم'),
                                                  onPressed: () {
                                                    setState(() {
                                                      removedCard =
                                                      userCardsList[
                                                      index];
                                                    });
                                                    Loader
                                                        .showUnDismissibleLoader(
                                                        context);

                                                    /// todo remove item
                                                    print(
                                                        '\n\nremove item json: ${json
                                                            .decode(
                                                            userCardsList[index])}\n\n');
                                                    print(
                                                        '\n\nremove item: ${removedCard}\n\n');
                                                    print(
                                                        '\n\nremove item length before: ${userCardsList
                                                            .length}\n\n');
                                                    userCardsList.remove(
                                                        removedCard);
                                                    print(
                                                        '\n\nremove item length after: ${userCardsList
                                                            .length}\n\n');
//                                                          print(
//                                                              '\n\nremove pricce: ${totalPrice - (json.decode(json.decode(userCardsList[index])['apiObject'])['value'] * json.decode(userCardsList[index])['apiObjectCount'])}\n\n');

                                                    updateSavedListAtShared(
                                                        userCardsList)
                                                        .then((updateState) =>
                                                    updateState
                                                        ? getTotalPrice()
                                                        .then(
                                                            (oldTotalPrice) {
                                                          print(
                                                              '\n\ntotal value oldTotalPrice: $oldTotalPrice\n\n');
                                                          print(
                                                              '\n\ntotal value newTotalPrice: ${totalPrice -
                                                                  (json.decode(
                                                                      json
                                                                          .decode(
                                                                          removedCard)['apiObject'])['value'] *
                                                                      json
                                                                          .decode(
                                                                          removedCard)['apiObjectCount'])}\n\n');

                                                          addTotalPrice(
                                                              totalPrice -
                                                                  (json.decode(
                                                                      json
                                                                          .decode(
                                                                          removedCard)['apiObject'])['value'] *
                                                                      json
                                                                          .decode(
                                                                          removedCard)['apiObjectCount']));
                                                        })
                                                        : userCardsList
                                                        .add(
                                                        removedCard));
                                                    Loader.hideDialog(
                                                        context);
                                                    Loader.hideDialog(
                                                        context);
                                                    if (userCardsList
                                                        .length ==
                                                        0) {
                                                      removeListFromShared();

                                                      Loader.hideDialog(
                                                          context);
                                                    }
                                                  },
                                                ),
                                                FlatButton(
                                                  child: Text('لا'),
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop();
                                                  },
                                                ),
                                              ],
                                            )),
                                child: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  child: Icon(
                                    Icons.clear,
                                    color: Colors.black,
                                  ),
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10),
                              child: Card(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(10.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.end,
                                    children: <Widget>[

                                      /// edit and update count
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
                                                  .start,
                                              children: <Widget>[
                                                GestureDetector(
                                                  onTap: () {
                                                    if (json.decode(
                                                        userCardsList[
                                                        index])[
                                                    'apiObjectCount'] >
                                                        0) {
                                                      setState(() {
                                                        num = json.decode(
                                                            json.decode(
                                                                userCardsList[index])[
                                                            'apiObject'])['value'];

                                                        userCardsList[
                                                        index] =
                                                            json.encode({
                                                              "apiObject": json
                                                                  .decode(
                                                                  userCardsList[index])[
                                                              'apiObject'],
                                                              "apiObjectCount":
                                                              json.decode(
                                                                  userCardsList[index])['apiObjectCount'] +
                                                                  1,
                                                            });

                                                        updateSavedListAtShared(
                                                            userCardsList)
                                                            .then((
                                                            updateState) =>
                                                        updateState
                                                            ? getTotalPrice()
                                                            .then((
                                                            oldTotalPrice) {
                                                          addTotalPrice(
                                                              totalPrice + num);
                                                        })
                                                            : null);
                                                      });
                                                    }
                                                  },
                                                  child: Container(
                                                    width: 20,
                                                    height: 20,
                                                    color: Colors.grey
                                                        .withOpacity(
                                                        .5),
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
                                                Padding(
                                                  padding:
                                                  const EdgeInsets
                                                      .only(
                                                      left: 5,
                                                      right: 5),
                                                  child: Text(
                                                    '${json.decode(
                                                        userCardsList[index])['apiObjectCount']}',
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    if (json.decode(
                                                        userCardsList[
                                                        index])[
                                                    'apiObjectCount'] >
                                                        1) {
                                                      setState(() {
                                                        num = json.decode(
                                                            json.decode(
                                                                userCardsList[index])[
                                                            'apiObject'])['value'];

                                                        userCardsList[
                                                        index] =
                                                            json.encode({
                                                              "apiObject": json
                                                                  .decode(
                                                                  userCardsList[index])[
                                                              'apiObject'],
                                                              "apiObjectCount":
                                                              json.decode(
                                                                  userCardsList[index])['apiObjectCount'] -
                                                                  1,
                                                            });

                                                        updateSavedListAtShared(
                                                            userCardsList)
                                                            .then((
                                                            updateState) =>
                                                        updateState
                                                            ? getTotalPrice()
                                                            .then((
                                                            oldTotalPrice) {
                                                          addTotalPrice(
                                                              totalPrice - num);
                                                        })
                                                            : null);
                                                      });
                                                    } else if (json.decode(
                                                        userCardsList[
                                                        index])[
                                                    'apiObjectCount'] ==
                                                        1) {
                                                      /// todo alert for removing
                                                      showDialog(
                                                          context:
                                                          context,
                                                          builder:
                                                              (context) =>
                                                              AlertDialog(
                                                                content:
                                                                ListTile(
                                                                  title: Text(
                                                                      "عملية الحذف"),
                                                                  subtitle: Text(
                                                                      "هل تريد حذف هذا العنصر"),
                                                                ),
                                                                actions: <
                                                                    Widget>[
                                                                  FlatButton(
                                                                    child: Text(
                                                                        'نعم'),
                                                                    onPressed: () {
                                                                      setState(() {
                                                                        removedCard =
                                                                        userCardsList[index];
                                                                      });
                                                                      Loader
                                                                          .showUnDismissibleLoader(
                                                                          context);

                                                                      /// todo remove item
                                                                      print(
                                                                          '\n\nremove item json: ${json
                                                                              .decode(
                                                                              userCardsList[index])}\n\n');
                                                                      print(
                                                                          '\n\nremove item: ${removedCard}\n\n');
                                                                      print(
                                                                          '\n\nremove item length before: ${userCardsList
                                                                              .length}\n\n');
                                                                      userCardsList
                                                                          .remove(
                                                                          removedCard);
                                                                      print(
                                                                          '\n\nremove item length after: ${userCardsList
                                                                              .length}\n\n');
//                                                          print(
//                                                              '\n\nremove pricce: ${totalPrice - (json.decode(json.decode(userCardsList[index])['apiObject'])['value'] * json.decode(userCardsList[index])['apiObjectCount'])}\n\n');

                                                                      updateSavedListAtShared(
                                                                          userCardsList)
                                                                          .then((
                                                                          updateState) =>
                                                                      updateState
                                                                          ? getTotalPrice()
                                                                          .then((
                                                                          oldTotalPrice) {
                                                                        print(
                                                                            '\n\ntotal value oldTotalPrice: $oldTotalPrice\n\n');
                                                                        print(
                                                                            '\n\ntotal value newTotalPrice: ${totalPrice -
                                                                                (json
                                                                                    .decode(
                                                                                    json
                                                                                        .decode(
                                                                                        removedCard)['apiObject'])['value'] *
                                                                                    json
                                                                                        .decode(
                                                                                        removedCard)['apiObjectCount'])}\n\n');

                                                                        addTotalPrice(
                                                                            totalPrice -
                                                                                (json
                                                                                    .decode(
                                                                                    json
                                                                                        .decode(
                                                                                        removedCard)['apiObject'])['value'] *
                                                                                    json
                                                                                        .decode(
                                                                                        removedCard)['apiObjectCount']));
                                                                      })
                                                                          : userCardsList
                                                                          .add(
                                                                          removedCard));
                                                                      Loader
                                                                          .hideDialog(
                                                                          context);
                                                                      Loader
                                                                          .hideDialog(
                                                                          context);
                                                                      if (userCardsList
                                                                          .length ==
                                                                          0) {
                                                                        removeListFromShared();

                                                                        Loader
                                                                            .hideDialog(
                                                                            context);
                                                                      }
                                                                    },
                                                                  ),
                                                                  FlatButton(
                                                                    child: Text(
                                                                        'لا'),
                                                                    onPressed: () {
                                                                      Navigator
                                                                          .of(
                                                                          context)
                                                                          .pop();
                                                                    },
                                                                  ),
                                                                ],
                                                              ));
                                                    }
                                                  },
                                                  child: Container(
                                                    width: 20,
                                                    height: 20,
                                                    color: Colors.grey
                                                        .withOpacity(
                                                        .5),
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

                                      /// adding card details
                                      Expanded(
                                        flex: 3,
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.only(
                                              right: 8),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .center,
                                            children: <Widget>[
                                              Text(
                                                '${json.decode(json.decode(
                                                    userCardsList[index])['apiObject'])['card']}',
                                              ),
                                              Text(
                                                '${json.decode(json.decode(
                                                    userCardsList[index])['apiObject'])['value']}',
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 1,
                                        height: MediaQuery
                                            .of(context)
                                            .size
                                            .height /
                                            9,
                                        color:
                                        Colors.grey.withOpacity(.5),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.only(
                                              right: 5),
                                          child: Container(
                                            child: Image.asset(
                                                "assets/image.png"),
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                            ),
                          ),
                        );
                      }))
                  : Container(
                  child: Center(
                    child: Text('لا يوجد مشتروات'),
                  ))
                  : Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Container(
                  alignment: Alignment.topRight,
                  height: 40,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.withOpacity(.5))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Icon(Icons.arrow_back),
                      ),
                      Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width / 1.4,
                          height: 40,
//margin: EdgeInsets.only(right: 10,top: 1),
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10, top: 8),
                            child: TextField(
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
                                hintText: "الرمز الترويجي",
                                border: InputBorder.none,
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () =>
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) => PaymentMethod())),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Container(
                      alignment: Alignment.topRight,
                      child: Text(
                        "طريقة الدفع",
                        style: TextStyle(fontSize: 18),
                      )),
                ),
              ),
              Divider(
                height: 3,
                color: Colors.grey,
              ),

              ///  add payment method names
              paymentMethod != null && paymentMethod.length > 0
                  ? Padding(
                padding: const EdgeInsets.only(right: 15, left: 15),
                child: Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                  new PaymentMethod()));
                        },
                        child: Text(
                          "تعديل",
                          style: TextStyle(
                              color: Color.fromRGBO(69, 57, 137, 1.0),
                              fontSize: 16),
                        ),
                      ),
                      GestureDetector(
                          onTap: () {},
                          child: Text(
                            "$paymentMethod",
                            style: TextStyle(fontSize: 16),
                          )),
                    ],
                  ),
                ),
              )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
