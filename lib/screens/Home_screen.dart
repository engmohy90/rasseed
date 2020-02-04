import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rasseed/functions/shared_services.dart';
import 'package:rasseed/globals.dart' as globals;
import 'package:rasseed/screens/login_screens/Login_with_flip.dart';
import 'package:rasseed/screens/my_cards/Cart_screen.dart';
import 'package:rasseed/screens/my_cards/ZainCard.dart';
import 'package:rasseed/screens/settings/Profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home_screen extends StatefulWidget {
  @override
  _Home_screenState createState() => _Home_screenState();
}

class _Home_screenState extends State<Home_screen> {
  String client_auth;
  String userCartNotEmpty = '';
  List<Color> listBorder = List();
  int cardAmount = 0;
  int listCount = 10;
  var loading = true;

  String client_full_name;

  bool isClientHasCards = false;

  var totalPrice = 0.0;

  void flusher_error(String title, String message) {
    Flushbar(
      backgroundColor: Colors.red,
      title: title,
      message: message,
      duration: Duration(milliseconds: 1500),
    )..show(context);
  }

  var image_data = [];
  List services_data = [];

  loginAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
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
                                isAnonymous: false,
                              ),
                            ),
                          );
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

  Future<String> get_auth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("client_auth");
  }

  Future<String> get_client_name() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("full_name");
  }

  Future<bool> is_client_has_cards() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("userHasCards");
  }

  Future<String> main_operators() async {
    print("main_operators");
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.getUrl(
      Uri.parse(
          "https://www.rasseed.com/api/method/ash7anly.flutter_api.get_main_class?_lang=ar"),
    );
    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    String replay = await response.transform(utf8.decoder).join();
    httpClient.close();
    print(replay);
    if (response.statusCode == 200) {
      try {
        print('\n\nimageData: ${json.decode(replay)}\n\n');
        var data = json.decode(replay);
        print('\n\nimageData data[0]\n: ${data['message'][0]}\n\n');
        print('\n\nimageData data[1]\n: ${data['message'][1]}\n\n');
//        print('\n\nimageData data[2]\n: ${data['message'][2]}\n\n');

        globals.mainClasses = data['message'][0];
        globals.operatorsByClass = data['message'][1];
//        globals.operatorsById = data['message'][2];

        print(
            '\n\nimageData globals.mainClasses\n: ${globals.mainClasses}\n\n');
        print(
            '\n\nimageData globals.operatorsByClass\n: ${globals.operatorsByClass}\n\n');
        print(
            '\n\nimageData globals.operatorsById\n: ${globals.operatorsById}\n\n');

        setState(() => loading = false);
        setState(() => services_data = globals.mainClasses);
        setState(() =>
            image_data = globals.operatorsByClass[globals.mainClasses[0]]);
        print('\n\nimageData image_data:\n $image_data\n\n');
        print(
            '\n\nimageData [operatorsByClass[0]]\n: ${globals.operatorsByClass[globals.mainClasses[0]]}\n\n');
      } catch (e) {
        // No specified type, handles all
        print('Something really unknown: $e');
      }
    } else {
      flusher_error("", "خطأ في تحميل البيانات");
    }

    return "done";
  }

  Future<bool> onWillPop(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Container(
          height: (MediaQuery.of(context).size.height / 100) * 25,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ListTile(
                title: Text(
                  "هل تريد الخروخ من التطبيق؟",
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    child: Text("خروج"),
                    onPressed: () {
                      SystemChannels.platform
                          .invokeMethod('SystemNavigator.pop');
                    },
                  ),
                  FlatButton(
                    child: Text("كلا"),
                    onPressed: () {
                      print('Tappped');
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    main_operators();
    get_auth().then(
      (clientAuth) => setState(() =>
          clientAuth != null ? client_auth = clientAuth : client_auth = null),
    );
    get_client_name().then(
      (clientName) => setState(() => clientName != null
          ? client_full_name = clientName
          : client_full_name = null),
    );
    is_client_has_cards().then(
      (clientHasCards) =>
          setState(() => isClientHasCards = clientHasCards ?? false),
    );
    getTotalPrice().then(
      (savedTotalPrice) => setState(() => totalPrice = savedTotalPrice ?? 0.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    is_client_has_cards().then(
      (clientHasCards) =>
          setState(() => isClientHasCards = clientHasCards ?? false),
    );
    getTotalPrice().then(
      (savedTotalPrice) => setState(() => totalPrice = savedTotalPrice ?? 0.0),
    );

    for (int i = 0; i < listCount; i++) {
      listBorder.add(
        Colors.grey.withOpacity(.5),
      );
    }
    if (loading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(69, 57, 137, 1.0),
          centerTitle: true,
          leading: Container(
            color: Color.fromRGBO(69, 57, 137, 1.0),
          ),
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: new CircularProgressIndicator(),
        ),
      );
    } else {
//      print('\n\n services_data: $services_data\n\n');
//      print('\n\n services_data.length: ${services_data.length}\n\n');
      return WillPopScope(
        onWillPop: () => onWillPop(context),
        child: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: isClientHasCards
              ? Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 20, bottom: 5, top: 5),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Cart_screen(),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: new BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            width: MediaQuery.of(context).size.width / 2,
                            child: Center(
                              child: Text(
                                "سلة التسوق",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Text("المجموع"),
                            ),
                            Container(
                              child: Text("$totalPrice"),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              : Container(),
          backgroundColor: Colors.white,
          body: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(69, 57, 137, 1.0),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20.0),
                    bottomLeft: Radius.circular(20.0),
                  ),
                ),
                height: MediaQuery.of(context).size.height / 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 22,
                    ),
                    ListTile(
                      leading: GestureDetector(
                        onTap: () {
                          client_auth != null && client_auth != "123"
                              ? Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        new Profile(),
                                  ),
                                )
                              : loginAlert();
                        },
                        child: CircleAvatar(
                          radius: 25,
                          child: Container(
                            width: 75.0,
                            height: 75.0,
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                image: AssetImage("assets/image.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          backgroundColor: Color.fromRGBO(69, 57, 137, 1.0),
                        ),
                      ),
                      title: Column(
                        children: <Widget>[
                          Container(
                              child:
                                  /* client_auth!=null
                                      ? Text("متجر رصيد ",
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 16),)
                                      : */
                                  Text(
                                "متجر رصيد",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              alignment: Alignment.centerRight),
                          client_full_name != null
                              ? Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "..هذه عروضنا لك " +
                                        client_full_name +
                                        "اهلا ب",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              : Container()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                margin: EdgeInsets.only(top: 90),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 4,
                      child: image_data != null
                          ? CarouselSlider(
                              enlargeCenterPage: true,
                              enableInfiniteScroll: true,
                              aspectRatio: 2.3,
                              viewportFraction: 0.8,
                              initialPage: 0,
                              items: image_data
                                  .map(
                                    (imageData) => Builder(
                                      builder: (BuildContext context) =>
                                          Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 8.0),
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
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8.0),
                                          ),
                                        ),
                                        child: Container(
                                          child: Image.network(
                                            Uri.encodeFull(
                                                "https://www.rasseed.com${imageData['flutter_img']}"),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            )
                          : null,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: userCartNotEmpty.isNotEmpty ? 8 : 0,
                          bottom: userCartNotEmpty.isNotEmpty ? 8 : 0),
                      width: MediaQuery.of(context).size.width,
                      height: 25,
                      child: services_data != null
                          ? services_data.length > 0
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: services_data
                                      .map(
                                        (item) => Builder(
                                            builder: (BuildContext context) =>
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() => image_data =
                                                        globals.operatorsByClass[
                                                            item]);
                                                  },
                                                  child: Container(
                                                    width: 70,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          new BorderRadius.all(
                                                        const Radius.circular(
                                                            8.0),
                                                      ),
                                                      border: Border.all(
                                                          color:
                                                              Colors.blue[900]),
                                                    ),
                                                    margin: EdgeInsets.only(
                                                        left: 7, right: 8),
                                                    child: Center(
                                                      child: Text("$item"),
                                                    ),
                                                  ),
                                                )),
                                      )
                                      .toList())
                              : Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'لا يوجد بيانات لعرضها!',
                                    textAlign: TextAlign.center,
                                  ),
                                )
                          : CircularProgressIndicator(),
                    ),
                    Container(
                      height: (MediaQuery.of(context).size.height / 100) *50,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(
                          bottom: userCartNotEmpty.isNotEmpty ? 29 : 0),
                      child: image_data != null
                          ? image_data.length > 0
                              ? GridView.builder(
                                  itemCount: image_data.length,
                                  padding: EdgeInsets.only(left: 18, top: 18, right: 18, bottom:(MediaQuery.of(context).size.height / 100) * 10),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2),
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        var route = new MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              new ZienCard(
                                                  operatorID: image_data[index]
                                                      ['id']),
                                        );
                                        Navigator.of(context).push(route);
                                      },
                                      child: Card(
                                        elevation: 1.0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Image.network(
                                            Uri.encodeFull(
                                                "https://www.rasseed.com${image_data[index]['flutter_img']}"),
                                            fit: BoxFit.contain),
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'لا يوجد بيانات لعرضها!',
                                    textAlign: TextAlign.center,
                                  ),
                                )
                          : CircularProgressIndicator(),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
