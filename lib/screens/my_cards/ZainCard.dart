import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:rasseed/functions/shared_services.dart';
import 'package:rasseed/screens/login_screens/Login_with_flip.dart';
import 'package:rasseed/utils/bottom_sheet_customize.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_animations/simple_animations/controlled_animation.dart';
import 'package:flushbar/flushbar.dart';

class ZienCard extends StatefulWidget {
  final String operatorID;

  ZienCard({@required this.operatorID});

  @override
  _ZienCardState createState() => _ZienCardState();
}

class _ZienCardState extends State<ZienCard> {
  GlobalKey<ScaffoldState> zienCardKey = GlobalKey();
  Color chargeBorder = Colors.grey.withOpacity(.5);
  Color interNetBorder = Colors.grey.withOpacity(.5);
  List<Color> listBorder = List();
  List<Color> listBorderClass = List();
  List<dynamic> cardsList;
  dynamic selectedCard;
  int cardAmount = 0;
  int listCount = 10;

//  double totalPrice = 0.0;
  String instruction = '';
  String instructionInfo1 = '';
  String instructionInfo2 = '';
  var operator;

  String clientAuth;

  Color cardAmountColor = Colors.white;
  Color selectedCardColor = Colors.white;
  Color cardsListColor = Colors.white;
    void flusher_error(String title, String message) {
        Flushbar(
              backgroundColor: Colors.red,
              title: title,
              message: message,
              duration: Duration(milliseconds: 1500),
        )..show(context);
      }

  loginAlert() {
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
                  "يجب عليك تسجيل الدخول اولا",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, top: 15, right: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
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
                    Container(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (BuildContext context) => FlipPage(
                                      isAnonymous: true,
                                      operatorID: widget.operatorID)));
                        },
                        child: Text(
                          "تسجيل دخول؟",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.green,
                              fontWeight: FontWeight.normal),
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

  Future<String> getAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("client_auth");
  }

  Future<String> getUserSID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('\n\n\n user sid: ${prefs.getString('client_auth')}\n\n\n');
    return prefs.getString('client_auth');
  }

  Future<dynamic> getOperator(String sid) async {
//    Loader.showUnDismissibleLoader(context);

    ///  https://www.rasseed.com/api/method/ash7anly.flutter_api.get_operator
    ///  ?sid=575dee3f85d943702480c80ac89e5309465e489d703653697d6a2a49
    ///  &_lang=ar
    ///  &main_operator=a82f32f060

    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(
        "https://www.rasseed.com/api/method/ash7anly.flutter_api.get_operator?"));

    request.headers.set('content-type', 'application/json');

    request.add(utf8.encode(json.encode(
        {"sid": sid, "_lang": "ar", "main_operator": widget.operatorID})));

    HttpClientResponse response = await request.close();

    print("\n\n status code is: ${response.statusCode}\n\n");

    // todo - you should check the response.statusCode
    String replay = await response.transform(utf8.decoder).join();
    httpClient.close();
    print("\n\n replay: $replay \n\n");

    if (response.statusCode == 200) {
//      Loader.hideDialog(context);

      setState(() {
        operator = List();
        print('\n\nbody is: ${json.decode(replay)['message']}\n\n');
        if (json.decode(replay)['message'] != null)
          json.decode(replay)['message'].forEach((cardData) => setState(() {
                if (cardData['cards'] != null && cardData['cards'].length > 0)
                  operator.add(cardData);
              }));
        for (int i = 0; i < operator.length; i++)
          listBorderClass.add(Colors.grey.withOpacity(.5));
      });
    } else {
//      Loader.hideDialog(context);
      print("\n\n replay: $replay from else \n\n");
      zienCardKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'حدث خطآ اثناء الاتصال بالانترنت...\nبرجاء المحاوله لاحقا!',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
          )));
    }

    print('\n\ncard list length: ${operator.length}\n\n');
  }

  @override
  void initState() {
    super.initState();
    getAuth().then((savedClientAuth) => setState(() => savedClientAuth != null
        ? clientAuth = savedClientAuth
        : clientAuth = null));

    getUserSID().then((savedSID) => getOperator(savedSID));
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Color.fromRGBO(69, 57, 137, 1.0));
    for (int i = 0; i < listCount; i++) {
      listBorder.add(Colors.grey.withOpacity(.5));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      key: zienCardKey,
      body: SingleChildScrollView(
          child: ControlledAnimation(
        duration: Duration(milliseconds: 500),
        tween: Tween<double>(begin: 1, end: 0),
        builder: (context, _animation) {
          return Container(
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * (_animation)),
            child: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 4,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(69, 57, 137, 1.0),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50)),
                  ),
                ),
                operator != null
                    ?
                operator.length > 0
                    ? Container(
                        margin: EdgeInsets.only(top: 40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            operator[0]['flutter_img'] != null
                                ? Container(
                                    margin: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height /
                                                10),
//                                    decoration: BoxDecoration(
//                                        borderRadius: BorderRadius.all(
//                                            Radius.circular(15.0))),
                                    width: MediaQuery.of(context).size.width *
                                        0.75,
                                    height:
                                        MediaQuery.of(context).size.height / 6,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.orangeAccent,
                                            Colors.orange,
                                            Colors.deepOrangeAccent,
                                            Colors.deepOrange,
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
//                                borderRadius: BorderRadius.all(
//                                    Radius.circular(8.0)),
                                        shape: BoxShape.circle),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Image.network(
                                        Uri.encodeFull(
                                            "https://www.rasseed.com${operator[0]['flutter_img']}"),
                                      ),
                                    ),
                                  )
                                : Container(
                                    margin: EdgeInsets.only(
                                        left: 25.0,
                                        right: 25.0,
                                        top:
                                            MediaQuery.of(context).size.height /
                                                12),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.0))),
                                    width: MediaQuery.of(context).size.width,
                                    height:
                                        MediaQuery.of(context).size.height / 4,
                                    child: Card(
                                      color: Color.fromRGBO(162, 194, 47, 1),
                                      elevation: 4.0,
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                            margin: EdgeInsets.only(right: 30),
                                            child: Text(
                                              operator[0]['operator'],
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 50),
                                            )),
                                      ),
                                    ),
                                  ),
                            Container(
                              alignment: Alignment.topRight,
                              margin: EdgeInsets.only(top: 15, right: 20),
                              child: Text(
                                'وصف البطاقة',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                              ),
                            ),
                            Container(
//                            margin: EdgeInsets.only(left: 20,top: 5.0),
                              child: Text(
                                '${instruction ?? ''}',
                                style: TextStyle(
                                    color: Colors.grey /*.withOpacity(.7)*/,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              margin: EdgeInsets.only(top: 15, right: 20),
                              child: Text(
                                'نوع البطاقة',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 20.0),
                              height: 40.0,
                              width: MediaQuery.of(context).size.width,
                              color: cardsListColor,
                              alignment: Alignment.center,
                              child: ListView.builder(
                                itemCount: operator.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        cardsListColor = Colors.white;
                                        cardsList = operator[index]['cards'];
                                        print(
                                            '\n\nselectedCard[instruction_1_ar]: ${operator[index]['instruction_1_ar']}\n\n');
                                        print(
                                            '\n\n selectedCard[instruction_2_a] : ${operator[index]['instruction_1_ar']}\n\n');

                                        for (int i = 0;
                                            i < operator.length;
                                            i++) {
                                          if (i == index) {
                                            listBorderClass[i] = Color.fromRGBO(
                                                69, 57, 137, 1.0);
                                          } else {
                                            listBorderClass[i] =
                                                Colors.grey.withOpacity(.5);
                                          }
                                        }

                                        instruction =
                                            operator[index]['shortcut'];

                                        instructionInfo1 =
                                            operator[index]['instruction_1_ar'];
                                        instructionInfo2 = operator[index]
                                                ['instruction_2_a'] ??
                                            'لا يتوفر تفاصيل طريقة الشحن حاليا!';
                                      });
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 80.0,
                                      margin: EdgeInsets.only(left: 8.0),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12)),
                                          border: Border.all(
                                              color: listBorderClass[index])),
                                      child: Text(
                                        '${operator[index]['child_title_ar']}',
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                69, 57, 137, 1.0),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              margin: EdgeInsets.only(top: 15, right: 20),
                              child: Text(
                                'قيمه البطاقة',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                              ),
                            ),
                            cardsList != null
                                ? Container(
                                    margin: EdgeInsets.only(right: 20.0),
                                    height: 40.0,
                                    width: MediaQuery.of(context).size.width,
                                    color: selectedCardColor,
                                    child: ListView.builder(
                                      itemCount: cardsList.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedCardColor = Colors.white;

                                              /// todo selected card
                                              selectedCard = cardsList[index];
                                              for (int i = 0;
                                                  i < listCount;
                                                  i++) {
                                                if (i == index) {
                                                  listBorder[i] =
                                                      Color.fromRGBO(
                                                          69, 57, 137, 1.0);
                                                } else {
                                                  listBorder[i] = Colors.grey
                                                      .withOpacity(.5);
                                                }
                                              }
                                            });
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: cardsList[index]['category']
                                                        .length >
                                                    7
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    4,
                                            margin: EdgeInsets.only(left: 8.0),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12)),
                                                border: Border.all(
                                                    color: listBorder[index])),
                                            child: Text(
                                              '${cardsList[index]['category']}',
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      69, 57, 137, 1.0),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : Container(),
                            Container(
                              alignment: Alignment.topRight,
                              margin: EdgeInsets.only(top: 15, right: 20),
                              child: Text(
                                'كميه البطاقه',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: Container(
                                width:
                                    (MediaQuery.of(context).size.width / 100) *
                                        40,
                                color: cardAmountColor,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    InkWell(
                                      highlightColor: Colors.white,
                                      splashColor: Colors.white,
                                      onTap: () {
                                        if (cardAmount < selectedCard['max_no_cards']){
                                          setState(() {
                                            cardAmountColor = Colors.white;
                                            cardAmount++;
                                          });}
                                        else{

                                          flusher_error("",  " أقصي عدد شراء في المره الواحدة ${selectedCard['max_no_cards']}") ;

                                        }

                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: 30.0,
                                        height: 30.0,
                                        margin: EdgeInsets.only(
                                            left: 15.0, right: 20.0),
                                        decoration: BoxDecoration(
                                            color: Color.fromRGBO(
                                                69, 57, 137, 0.4),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12)),
                                            border: Border.all(
                                                color: Color.fromRGBO(
                                                    69, 57, 137, 0.4))),
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 15.0,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        '${cardAmount ?? '0'}',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => setState(() {
                                        cardAmountColor = Colors.white;
                                        if (cardAmount > 0) {
                                          cardAmount--;
                                        }
                                      }),
                                      splashColor: Colors.white,
                                      highlightColor: Colors.white,
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: 30.0,
                                        height: 30.0,
                                        margin: EdgeInsets.only(
                                            left: 15.0, right: 15.0),
                                        decoration: BoxDecoration(
                                            color: Color.fromRGBO(
                                                69, 57, 137, 0.4),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12)),
                                            border: Border.all(
                                                color: Color.fromRGBO(
                                                    69, 57, 137, 0.4))),
                                        child: Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                          size: 15.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => showRoundedModalBottomSheet(
                                autoResize: true,
                                dismissOnTap: false,
                                context: context,
                                radius: 20.0,
                                // This is the default
                                color: Colors.white,
                                // Also default
                                builder: (context) => Container(
                                  height:
                                      MediaQuery.of(context).size.height / 3,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      instructionInfo1 != null &&
                                              instructionInfo1.length > 1
                                          ? Container(
                                              alignment: Alignment.topRight,
                                              margin: EdgeInsets.only(
                                                  top: 15, right: 20),
                                              child: Text(
                                                '$instructionInfo1',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black),
                                              ),
                                            )
                                          : Container(),
                                      instructionInfo2 != null &&
                                              instructionInfo2.length > 1
                                          ? Container(
                                              alignment: Alignment.topRight,
                                              margin: EdgeInsets.only(
                                                  top: 15, right: 20),
                                              child: Text(
                                                '$instructionInfo2',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            )
                                          : Container(),
                                      instructionInfo1 != null &&
                                              instructionInfo2.length < 1
                                          ? Container(
                                              alignment: Alignment.topRight,
                                              margin: EdgeInsets.only(
                                                  top: 15, right: 20),
                                              child: Text(
                                                'لا يتوفر تفاصيل طريقة الشحن حاليا!',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ),
                              child: Container(
                                alignment: Alignment.centerRight,
                                margin: EdgeInsets.only(
                                    top: 15.0,
                                    right: 20.0,
                                    left: MediaQuery.of(context).size.width /
                                        1.8),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(69, 57, 137, 0.3),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        "ماهى طريقه الشحن؟",
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                69, 57, 137, 1.0),
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Container(
                                      child: Icon(
                                        Icons.info_outline,
                                        color: Color.fromRGBO(69, 57, 137, 1.0),
                                        size: 20.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              margin: EdgeInsets.only(top: 10, right: 20),
                              child: Text(
                                'لديك '
                                '${selectedCard != null ? selectedCard['mycredits'] ?? 0 : 0}'
                                ' بطاقات من هذا النوع',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromRGBO(69, 57, 137, 1)),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  right: 20.0,
                                  left: 20.0,
                                  bottom: 15.0,
                                  top: 15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  GestureDetector(
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 120.0,
                                      height: 60.0,
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(69, 57, 137, 1.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                      ),
                                      child: Text(
                                        "إضافة إلى السلة+",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    onTap: () {
                                      if (clientAuth != null &&
                                          clientAuth != "123") {
                                        /// todo post user request to API
                                        if (cardsList != null) if (selectedCard !=
                                            null) if (cardAmount > 0)
                                          getListFromShared().then((savedList) {
                                            if (savedList != null &&
                                                savedList.length > 0) {
                                              savedList.add(json.encode({
                                                "apiObject":
                                                    json.encode(selectedCard),
                                                "apiObjectCount": cardAmount,
                                              }));
                                              if (savedList != null)
                                                print(
                                                    '\n\ntotal value savedList: $savedList\n\n');
                                              print(
                                                  '\n\ntotal value savedList[0]: ${savedList[0]}\n\n');
                                              saveListToShared(savedList)
                                                  .then((listSaved) {
                                                if (listSaved == false)
                                                  saveListToShared(savedList);

                                                getTotalPrice()
                                                    .then((oldTotalPrice) {
                                                  print(
                                                      '\n\nfinal total price: ${(selectedCard['value'] * cardAmount) + oldTotalPrice}\n\n');

                                                  print(
                                                      '\n\ntotal value oldTotalPrice: $oldTotalPrice\n\n');
                                                  print(
                                                      '\n\ntotal value new TotalPrice: ${(selectedCard['value'] * cardAmount)}\n\n');

                                                  addTotalPrice((selectedCard[
                                                                  'value'] *
                                                              cardAmount) +
                                                          oldTotalPrice)
                                                      .then((totalPriceSaved) =>
                                                          totalPriceSaved
                                                              ? Navigator.pop(
                                                                  context)
                                                              : addTotalPrice(
                                                                  (selectedCard[
                                                                          'value'] *
                                                                      cardAmount)));
                                                });
                                              });
                                            } else {
                                              saveListToShared([
                                                json.encode({
                                                  "apiObject":
                                                      json.encode(selectedCard),
                                                  "apiObjectCount": cardAmount,
                                                })
                                              ]).then((listSaved) {
                                                if (listSaved == false)
                                                  saveListToShared(savedList);

                                                getTotalPrice()
                                                    .then((oldTotalPrice) {
                                                  print(
                                                      '\n\nfinal total price: ${(selectedCard['value'] * cardAmount) + oldTotalPrice}\n\n');
                                                  print(
                                                      '\n\ntotal value oldTotalPrice: $oldTotalPrice\n\n');
                                                  print(
                                                      '\n\ntotal value new TotalPrice: ${(selectedCard['value'] * cardAmount)}\n\n');

                                                  addTotalPrice((selectedCard[
                                                                  'value'] *
                                                              cardAmount) +
                                                          oldTotalPrice)
                                                      .then((totalPriceSaved) =>
                                                          totalPriceSaved
                                                              ? Navigator.pop(
                                                                  context)
                                                              : addTotalPrice(
                                                                  (selectedCard[
                                                                          'value'] *
                                                                      cardAmount)));
                                                });
                                              });
                                            }
                                          });
                                        else {
                                          setState(() {
                                            cardAmountColor =
                                                Colors.red.withOpacity(0.3);
                                          });

                                          zienCardKey.currentState
                                              .showSnackBar(SnackBar(
                                                  backgroundColor: Colors.red,
                                                  content: Text(
                                                    'يجب أضافه العدد المطلوب',
                                                    textAlign: TextAlign.center,
                                                  )));
                                        }
                                        else {
                                          setState(() {
                                            selectedCardColor =
                                                Colors.red.withOpacity(0.3);
                                          });

                                          zienCardKey.currentState
                                              .showSnackBar(SnackBar(
                                                  backgroundColor: Colors.red,
                                                  content: Text(
                                                    'يجب اخيار قيمة اليطاقه',
                                                    textAlign: TextAlign.center,
                                                  )));
                                        }
                                        else {
                                          setState(() {
                                            cardsListColor =
                                                Colors.red.withOpacity(0.3);
                                          });

                                          zienCardKey.currentState
                                              .showSnackBar(SnackBar(
                                                  backgroundColor: Colors.red,
                                                  content: Text(
                                                    'يجب اخيار نوع اليطاقه',
                                                    textAlign: TextAlign.center,
                                                  )));
                                        }
                                      } else
                                        loginAlert();
                                    },
                                  ),
                                  Container(
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            'المجموع',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            selectedCard != null
                                                ? "${selectedCard['value'] * cardAmount} رس "
                                                : "0 رس",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black),
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
                      )
                    : Container()
                    : Container(
                        margin: EdgeInsets.only(top: 40.0),
                        height: (MediaQuery.of(context).size.height / 100) * 60,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator()),
                operator != null
                    ?
                operator.length > 0
                    ? Container(
                        margin: EdgeInsets.only(left: 40, top: 30.0, right: 40),
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          operator[0]['operator'],
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 24.0),
                        ),
                      )
                    : Container(
                    margin: EdgeInsets.only(top: 40.0),
                    height: (MediaQuery.of(context).size.height / 100) * 60,
                    alignment: Alignment.center,
                    child: Text('لا يوجد بيانات لعرضها'))
                    : Container(),
                Container(
                  margin: EdgeInsets.only(
                    top: 30.0,
                  ),
                  alignment: Alignment.centerRight,
                  child: IconButton(
                      icon: Icon(Icons.close, color: Colors.white, size: 25.0),
                      onPressed: () => Navigator.pop(context)),
                ),
              ],
            ),
          );
        },
      )),
    );
  }
}
