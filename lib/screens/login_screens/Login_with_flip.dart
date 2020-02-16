import 'dart:convert';
import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:persian_numbers/persian_numbers.dart';
import 'package:rasseed/screens/login_screens/verfiy_login.dart';
import 'package:rasseed/utils/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Home_screen.dart';

class FlipPage extends StatefulWidget {
  final bool isAnonymous;
  final String operatorID;

  const FlipPage({Key key, this.isAnonymous, this.operatorID}) : super(key: key);

  @override
  _FlipPageState createState() => _FlipPageState();
}

class _FlipPageState extends State<FlipPage> {
  GlobalKey<ScaffoldState> loginWithFlipScaffoldKey = GlobalKey();
  String _dialCode = "";
  TextEditingController phone_controoler = TextEditingController();

  String _dialCode2 = "";
  TextEditingController phone_controoler2 = TextEditingController();
  TextEditingController first_name_controoler = TextEditingController();
  TextEditingController last_name__controoler = TextEditingController();
  TextEditingController email_controoler = TextEditingController();
  int valuechanged = 0; // sms defualt
  int langValueChanged = 0; // sms defualt
  var finalresult = 0.0;
  int valuechanged2 = 2; // normal defualt
  var finalresult2 = 0.0;
  String msg_via, userLang, work_as;
  TextEditingController message_error_controoler = TextEditingController();

  void valuechangedfunc(int value) {
    setState(() {
      valuechanged = value;
      if (valuechanged == 0) {
      } else if (valuechanged == 1) {}
    });
  }

  void langValueChangedFunc(int value) {
    setState(() {
      langValueChanged = value;
      if (langValueChanged == 0) {
      } else if (langValueChanged == 1) {}
    });
  }

  set_auth(String auth) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("client_auth", auth);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Home_screen()),
        (dynamic) => false);
  }

  void valuechangedfunc2(int value) {
    setState(() {
      valuechanged2 = value;
      if (valuechanged2 == 0) {
      } else if (valuechanged2 == 1) {}
    });
  }

  void flusher_error(String message) {
    Flushbar(
      backgroundColor: Colors.red,
      title: "فشل الدخول ",
      message: message,
      duration: Duration(milliseconds: 1500),
    )..show(context);
  }

  void _showDialog(String title, String content, Widget Navigator_) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(content),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                print("dddd1111");
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Navigator_));
                print("dddd12222");
//                Navigator.of(context).pop();
                print("dddd333311");
              },
            ),
          ],
        );
      },
    );
  }

  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  Future<String> login_screen() async {
    RegExp exp = new RegExp(r"(^[5]\d{8})");
    String str = phone_controoler.text;
    str = str.replaceAll("١","1").replaceAll("٢","2").replaceAll("٣","3").replaceAll("٤","4").replaceAll("٥","5").replaceAll("٦","6").replaceAll("٧","7").replaceAll("٨","8").replaceAll("٩","9").replaceAll("٠","0");

    print("ttttttttttttttttt${str}");


    bool phone_exp = exp.hasMatch(str);

    if (phone_exp == false) {
      print("UUYY&&");
      message_error_controoler.text =
          "رقم الهاتف يجب أن يكون 9 أرقام ويبدأ برقم 5، مثال: 598765432";

//                                                    XsProgressHud.hide();
      Loader.hideDialog(context);
    } else {
      print("IIOOPPP");
      if (valuechanged == 0) {
        msg_via = "sms";
      } else {
        msg_via = "whatsapp";
      }

      Loader.showUnDismissibleLoader(context);

      /// todo endpoint
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.postUrl(
          Uri.parse("https://www.rasseed.com/api/method/ash7anly.auth1.login"));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(
          json.encode({"phone": str, "msg_via": msg_via})));
      HttpClientResponse response = await request.close();

      print("\n\n${response.statusCode}dssaaadxxsd\n\n");

      // todo - you should check the response.statusCode
      String replay = await response.transform(utf8.decoder).join();
      httpClient.close();
      print("\n\n${replay}dssaaadxxsd\n\n");

      Loader.hideDialog(context);
      print("ggggg${response.statusCode}");
      if (response.statusCode == 200) {
//        Loader.hideDialog(context);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => verfiy_login(phone_controoler.text,isAnonymous: widget.isAnonymous?? false, operatorID: widget.operatorID)));
      } else {
        Loader.hideDialog(context);
        message_error_controoler.text = json.decode(replay)['message'];
        loginWithFlipScaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Container(
              width: MediaQuery.of(context).size.width,
              child: Text(
                '${json.decode(replay)['message'] ?? 'فشل تسجيل الدخول!'}',
                textAlign: TextAlign.center,
              )),
        ));
      }
    }

    return "done";
  }

  Future<String> signup_screen() async {
    ///todo add lang

    if (langValueChanged == 0) {
      userLang = "ar";
    } else {
      userLang = "en";
    }

    RegExp exp = new RegExp(r"(^[5]\d{8})");
    String str = phone_controoler2.text;
    bool phone_exp = exp.hasMatch(str);

    RegExp exp_email = new RegExp(
        r"(^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$)");
    String str_email = email_controoler.text;
    bool valid_email_exp = exp_email.hasMatch(str_email);

    if (phone_exp == false) {
//                                                    XsProgressHud.hide();
      Loader.hideDialog(context);

      flusher_error(
          "رقم الهاتف يجب أن يكون 9 أرقام ويبدأ برقم 5، مثال: 598765432");
    }
    if (valid_email_exp == false) {
//                                                    XsProgressHud.hide();
      Loader.hideDialog(context);

      flusher_error("الرجاء ادخال ايميل صحيح");
    } else {
      if (valuechanged2 == 2) {
        work_as = "buyer";
      } else {
        work_as = "seller";
      }

      Loader.showUnDismissibleLoader(context);
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.postUrl(Uri.parse(
          "https://www.rasseed.com/api/method/ash7anly.auth1.signup"));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(json.encode({
        "phone": phone_controoler2.text,
        "full_name": first_name_controoler.text +" "+ last_name__controoler.text,
        "email": email_controoler.text,
        "work_as": work_as,
        "language": "ar",
        "msg_via": "sms"
      })));
      HttpClientResponse response = await request.close();
      // todo - you should check the response.statusCode
      String replay = await response.transform(utf8.decoder).join();
      httpClient.close();
      print("${replay}signuppppppp");

//      XsProgressHud.hide();
      Loader.hideDialog(context);
      print("ggggg${response.statusCode}");
      if (response.statusCode == 200) {
        Loader.hideDialog(context);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => verfiy_login(phone_controoler2.text,isAnonymous: widget.isAnonymous?? false, operatorID: widget.operatorID)));
      } else if (response.statusCode == 409) {
        Loader.hideDialog(context);
        _showDialog("تنبيه", json.decode(replay)['message'],
            verfiy_login(phone_controoler2.text,isAnonymous: widget.isAnonymous?? false, operatorID: widget.operatorID));
      } else {
        Loader.hideDialog(context);
        flusher_error(json.decode(replay)['message']);
      }
    }

    return "done";
  }

//  @override
//  void initState() {
//    super.initState();
//
//    SystemChannels.textInput.invokeMethod('TextInput.hide');
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: loginWithFlipScaffoldKey,
      body: FlipCard(
        key: cardKey,
        flipOnTouch: false,
        front: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(69, 57, 137, 1.0),
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0)),
                  ),
                  height: MediaQuery.of(context).size.height / 2.5,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 10,
                        ),
                        Center(
                          child: CircleAvatar(
                            radius: 35,
                            child: Container(
                                width: 140.0,
                                height: 140.0,
                                decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                    image: AssetImage("assets/image.png"),
                                    fit: BoxFit.cover,
                                  ),
                                )),
                            backgroundColor: Color.fromRGBO(69, 57, 137, 1.0),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 40,
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                              child: Text("تسجيل دخول",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 24)),
                              alignment: Alignment.centerRight),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 160, right: 30, left: 30),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 1.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Column(
                                children: <Widget>[
                                  Card(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, right: 20),
                                            child: Container(
                                                child: Text("ادخل رقم جوالك",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14)),
                                                alignment:
                                                    Alignment.centerRight),
                                          ),
                                          Card(
                                            margin: EdgeInsets.only(
                                                left: 20,
                                                right: 20,
                                                top: 10,
                                                bottom: 10),
                                            elevation: 0,
                                            color: Colors.white,
                                            shape: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.grey
                                                      .withOpacity(0.2),
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Container(
                                              height: 40,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  CountryCodePicker(
                                                    onChanged: (print) {
                                                      _dialCode =
                                                          print.dialCode;
                                                    },
                                                    textStyle:
                                                        TextStyle(fontSize: 12),
                                                    initialSelection: 'SA',
                                                    favorite: ['+966', 'SA'],
                                                    showCountryOnly: true,
                                                    showFlag: true,
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 5, bottom: 5),
                                                    child: Container(
                                                      width: 2,
                                                      height: 40,
                                                      color: Colors.grey
                                                          .withOpacity(0.1),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 0),
                                                      child: TextField(
                                                        controller:
                                                            phone_controoler,
                                                        autofocus: false,
                                                        textAlign:
                                                            TextAlign.center,
//                                                        focusNode:  FocusScope.of(context).unfocus(),
                                                        focusNode: FocusNode(),
//                                                        onChanged: (val) {
//                                                          setState(() {});
//                                                        },

                                                        style: TextStyle(
                                                            fontSize: 14),
                                                        maxLines: 1,
                                                        keyboardType:
                                                            TextInputType.phone,
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              "ادخل رقم جوالك",
                                                          border:
                                                              InputBorder.none,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, right: 20),
                                            child: Container(
                                                child: TextField(
                                                    controller:
                                                        message_error_controoler,
                                                    readOnly: true,
                                                    autofocus: false,
                                                    textAlign: TextAlign.center,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                    ),
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 12)),
                                                alignment:
                                                    Alignment.centerRight),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, right: 20),
                                            child: Container(
                                                child: Text(
                                                    "طريقة ارسال رمز التحقق",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14)),
                                                alignment:
                                                    Alignment.centerRight),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 60),
                                            child: Container(
                                              alignment: Alignment.centerLeft,
                                              child: new Row(
                                                children: <Widget>[
                                                  new Text(
                                                    "رسالة نصية",
                                                    style: new TextStyle(
                                                      color: Color.fromRGBO(
                                                          69, 57, 137, 1.0),
                                                    ),
                                                  ),
                                                  new Radio<int>(
                                                      activeColor:
                                                          Color.fromRGBO(
                                                              69, 57, 137, 1.0),
                                                      value: 0,
                                                      groupValue: valuechanged,
                                                      onChanged:
                                                          valuechangedfunc),
                                                  new Text(
                                                    "رسالة واتس اب",
                                                    style: new TextStyle(
                                                      color: Color.fromRGBO(
                                                          69, 57, 137, 1.0),
                                                    ),
                                                  ),
                                                  new Radio<int>(
                                                      activeColor:
                                                          Color.fromRGBO(
                                                              69, 57, 137, 1.0),
                                                      value: 2,
                                                      groupValue: valuechanged,
                                                      onChanged:
                                                          valuechangedfunc)
                                                ],
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    color: Color.fromRGBO(
                                                        69, 57, 137, 1.0),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(10.0),
                                                    )),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2,
                                                height: 30,
                                                child: RaisedButton(
                                                  onPressed: () {
//                                                  XsProgressHud.show(context);
                                                    Loader
                                                        .showUnDismissibleLoader(
                                                            context);
                                                    if (phone_controoler.text ==
                                                        "") {
//                                                    XsProgressHud.hide();
                                                      Loader.hideDialog(
                                                          context);

                                                      message_error_controoler
                                                              .text =
                                                          "الرجاء ادخال رقم الجوال";
                                                    } else {
                                                      login_screen();
                                                    }
                                                  },
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(10.0),
                                                  ),
                                                  color: Color.fromRGBO(
                                                      69, 57, 137, 1.0),
                                                  child: Text(
                                                    "دخول",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                )),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  FlatButton(
                                      onPressed: () {

                                        set_auth("123");
                                      },
                                      child: Text(
                                        "التسجيل لاحقا ",
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                69, 57, 137, 1.0)),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () =>
                                              cardKey.currentState.toggleCard(),
                                          child: Text(
                                            " سجل الان  ",
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    69, 57, 137, 1.0)),
                                          ),
                                        ),
                                        Text(
                                          "ليس لديك حساب في رصيد ؟   ",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Center(
                                child: CircleAvatar(
                              radius: 35,
                              child: Container(
                                  width: 140.0,
                                  height: 140.0,
                                  decoration: new BoxDecoration(
                                    border: Border.all(
                                        width: 4, color: Colors.white),
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                      image: AssetImage("assets/image.png"),
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                              backgroundColor: Color.fromRGBO(69, 57, 137, 1.0),
                            ))
                          ],
                        )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        back: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(69, 57, 137, 1.0),
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0)),
                  ),
                  height: MediaQuery.of(context).size.height / 2.5,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: CircleAvatar(
                            radius: 35,
                            child: Container(
                                width: 140.0,
                                height: 140.0,
                                decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                    image: AssetImage("assets/image.png"),
                                    fit: BoxFit.cover,
                                  ),
                                )),
                            backgroundColor: Color.fromRGBO(69, 57, 137, 1.0),
                          ),
                        ),
                        Container(
                            child: Text("تسجيل جديد",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 24)),
                            alignment: Alignment.centerRight),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 85, right: 30, left: 30),
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Column(
                                children: <Widget>[
                                  Card(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 40,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 30),
                                                      child: Container(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Text(
                                                              "الاسم الاخير")),
                                                    ),
                                                    Card(
                                                      margin: EdgeInsets.only(
                                                          right: 20,
                                                          left: 20,
                                                          bottom: 20),
                                                      elevation: 0,
                                                      color: Colors.white,
                                                      shape: OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.3),
                                                            width: 1,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child: TextField(
                                                        textAlign:
                                                            TextAlign.center,
                                                        controller:
                                                            last_name__controoler,
                                                        autofocus: false,
                                                        onChanged: (val) {},
                                                        style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontSize: 15,
                                                        ),
                                                        decoration:
                                                            InputDecoration(
                                                          hintText: "خالد",
                                                          hintStyle: TextStyle(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w100),
                                                          border:
                                                              InputBorder.none,
                                                          contentPadding:
                                                              EdgeInsets.only(
                                                                  left: 20,
                                                                  top: 5,
                                                                  bottom: 5,
                                                                  right: 40),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                flex: 1,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 30),
                                                      child: Container(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Text(
                                                              "الاسم  الاول")),
                                                    ),
                                                    Card(
                                                      margin: EdgeInsets.only(
                                                          right: 20,
                                                          left: 20,
                                                          bottom: 20),
                                                      elevation: 0,
                                                      color: Colors.white,
                                                      shape: OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.3),
                                                            width: 1,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child: TextField(
                                                        controller:
                                                            first_name_controoler,
                                                        onChanged: (val) {},
                                                        autofocus: false,
                                                        style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontSize: 15,
                                                        ),
                                                        decoration:
                                                            InputDecoration(
                                                          hintText: "عمر",
                                                          hintStyle: TextStyle(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w100),
                                                          border:
                                                              InputBorder.none,
                                                          contentPadding:
                                                              EdgeInsets.only(
                                                                  left: 45,
                                                                  top: 5,
                                                                  bottom: 5,
                                                                  right: 20),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                flex: 1,
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, right: 20),
                                            child: Container(
                                                child: Text("ادخل رقم جوالك",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14)),
                                                alignment:
                                                    Alignment.centerRight),
                                          ),
//                                        Card(
//                                          margin: EdgeInsets.only(
//                                              left: 20,
//                                              right: 20,
//                                              top: 10,
//                                              bottom: 10),
//                                          elevation: 0,
//                                          color: Colors.white,
//                                          shape: OutlineInputBorder(
//                                              borderSide: BorderSide(
//                                                color: Colors.grey
//                                                    .withOpacity(0.2),
//                                                width: 1,
//                                              ),
//                                              borderRadius:
//                                                  BorderRadius.circular(10)),
//                                          child: Container(
//                                            height: 40,
//                                            child: Row(
//                                              mainAxisAlignment:
//                                                  MainAxisAlignment.start,
//                                              crossAxisAlignment:
//                                                  CrossAxisAlignment.center,
//                                              children: <Widget>[
//                                                CountryCodePicker(
//                                                  onChanged: (print) {
//                                                    _dialCode = print.dialCode;
//                                                  },
//                                                  textStyle:
//                                                      TextStyle(fontSize: 12),
//                                                  initialSelection: 'SA',
//                                                  favorite: ['+966', 'SA'],
//                                                  showCountryOnly: false,
//                                                ),
//                                                Padding(
//                                                  padding: EdgeInsets.only(
//                                                      top: 5, bottom: 5),
//                                                  child: Container(
//                                                    width: 2,
//                                                    height: 40,
//                                                    color: Colors.grey
//                                                        .withOpacity(0.1),
//                                                  ),
//                                                ),
//                                                Expanded(
//                                                  child: Padding(
//                                                    padding:
//                                                        const EdgeInsets.only(
//                                                            top: 0),
//                                                    child: TextField(
//                                                      controller:
//                                                          phone_controoler2,
//                                                      autofocus: true,
//                                                      textAlign:
//                                                          TextAlign.center,
//                                                      onChanged: (val) {
//                                                        setState(() {});
//                                                      },
//                                                      style: TextStyle(
//                                                          fontSize: 14),
//                                                      maxLines: 1,
//                                                      keyboardType:
//                                                          TextInputType.phone,
//                                                      decoration:
//                                                          InputDecoration(
//                                                        hintText:
//                                                            "ادخل رقم جوالك",
//                                                        border:
//                                                            InputBorder.none,
//                                                      ),
//                                                    ),
//                                                  ),
//                                                ),
//                                              ],
//                                            ),
//                                          ),
//                                        ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Card(
                                                  margin: EdgeInsets.only(
                                                      left: 20,
                                                      right: 20,
                                                      top: 10,
                                                      bottom: 10),
                                                  elevation: 0,
                                                  color: Colors.white,
                                                  shape: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.grey
                                                            .withOpacity(0.2),
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Container(
                                                    height: 40,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        CountryCodePicker(
                                                          onChanged: (print) {
                                                            _dialCode =
                                                                print.dialCode;
                                                          },
                                                          textStyle: TextStyle(
                                                              fontSize: 12),
                                                          initialSelection:
                                                              'SA',
                                                          favorite: [
                                                            '+966',
                                                            'SA'
                                                          ],
                                                          showCountryOnly: true,
                                                          showFlag: true,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 5,
                                                                  bottom: 5),
                                                          child: Container(
                                                            width: 2,
                                                            height: 40,
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.1),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 0),
                                                            child: TextField(
                                                              controller:
                                                                  phone_controoler2,
                                                              autofocus: false,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              onChanged: (val) {
                                                                setState(() {});
                                                              },
                                                              style: TextStyle(
                                                                  fontSize: 14),
                                                              maxLines: 1,
                                                              keyboardType:
                                                                  TextInputType
                                                                      .phone,
                                                              decoration:
                                                                  InputDecoration(
                                                                hintText:
                                                                    "ادخل رقم جوالك",
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 60),
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: new Row(
                                                      children: <Widget>[
                                                        new Text(
                                                          "اللغه العربية",
                                                          style: new TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    69,
                                                                    57,
                                                                    137,
                                                                    1.0),
                                                          ),
                                                        ),
                                                        new Radio<int>(
                                                            activeColor:
                                                                Color.fromRGBO(
                                                                    69,
                                                                    57,
                                                                    137,
                                                                    1.0),
                                                            value: 0,
                                                            groupValue:
                                                                langValueChanged,
                                                            onChanged:
                                                                langValueChangedFunc),
                                                        new Text(
                                                          "اللغه الانجليزية",
                                                          style: new TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    69,
                                                                    57,
                                                                    137,
                                                                    1.0),
                                                          ),
                                                        ),
                                                        new Radio<int>(
                                                            activeColor:
                                                                Color.fromRGBO(
                                                                    69,
                                                                    57,
                                                                    137,
                                                                    1.0),
                                                            value: 2,
                                                            groupValue:
                                                                langValueChanged,
                                                            onChanged:
                                                                langValueChangedFunc)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20, right: 20),
                                                  child: Container(
                                                      child: Text(
                                                          "طريقة ارسال رمز التحقق",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14)),
                                                      alignment: Alignment
                                                          .centerRight),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 60),
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: new Row(
                                                      children: <Widget>[
                                                        new Text(
                                                          "رسالة نصية",
                                                          style: new TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    69,
                                                                    57,
                                                                    137,
                                                                    1.0),
                                                          ),
                                                        ),
                                                        new Radio<int>(
                                                            activeColor:
                                                                Color.fromRGBO(
                                                                    69,
                                                                    57,
                                                                    137,
                                                                    1.0),
                                                            value: 0,
                                                            groupValue:
                                                                valuechanged,
                                                            onChanged:
                                                                valuechangedfunc),
                                                        new Text(
                                                          "رسالة واتس اب",
                                                          style: new TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    69,
                                                                    57,
                                                                    137,
                                                                    1.0),
                                                          ),
                                                        ),
                                                        new Radio<int>(
                                                            activeColor:
                                                                Color.fromRGBO(
                                                                    69,
                                                                    57,
                                                                    137,
                                                                    1.0),
                                                            value: 2,
                                                            groupValue:
                                                                valuechanged,
                                                            onChanged:
                                                                valuechangedfunc)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, right: 20),
                                            child: Container(
                                                child: Text("البريد الالكتروني",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14)),
                                                alignment:
                                                    Alignment.centerRight),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15, right: 15),
                                            child: Card(
                                              elevation: 0,
                                              color: Colors.white,
                                              shape: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.grey
                                                        .withOpacity(0.2),
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: TextField(
                                                controller: email_controoler,
                                                onChanged: (val) {
                                                  setState(() {});
                                                },
                                                textAlign: TextAlign.right,
                                                autofocus: false,
                                                style: TextStyle(fontSize: 15),
                                                maxLines: 1,
                                                decoration: InputDecoration(
                                                  hintText: "my@****    ",
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, right: 20),
                                            child: Container(
                                                child: Text("نوع الحساب  ",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14)),
                                                alignment:
                                                    Alignment.centerRight),
                                          ),
                                          Container(
                                            alignment: Alignment.centerRight,
                                            child: new Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                new Text(
                                                  "  تاجر",
                                                  style: new TextStyle(
                                                    color: Color.fromRGBO(
                                                        69, 57, 137, 1.0),
                                                  ),
                                                ),
                                                new Radio<int>(
                                                    activeColor: Color.fromRGBO(
                                                        69, 57, 137, 1.0),
                                                    value: 0,
                                                    groupValue: valuechanged2,
                                                    onChanged:
                                                        valuechangedfunc2),
                                                new Text(
                                                  " عادي",
                                                  style: new TextStyle(
                                                    color: Color.fromRGBO(
                                                        69, 57, 137, 1.0),
                                                  ),
                                                ),
                                                new Radio<int>(
                                                    activeColor: Color.fromRGBO(
                                                        69, 57, 137, 1.0),
                                                    value: 2,
                                                    groupValue: valuechanged2,
                                                    onChanged:
                                                        valuechangedfunc2)
                                              ],
                                            ),
                                          ),
                                          Center(
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    color: Color.fromRGBO(
                                                        69, 57, 137, 1.0),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(10.0),
                                                    )),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2,
                                                height: 30,
                                                child: RaisedButton(
                                                  onPressed: () {
//                                                  XsProgressHud.show(context);

                                                    Loader
                                                        .showUnDismissibleLoader(
                                                            context);
                                                    if (phone_controoler2
                                                            .text ==
                                                        "") {
//                                                    XsProgressHud.hide();
                                                      Loader.hideDialog(
                                                          context);
                                                      flusher_error(
                                                          "الرجاء ادخال رقم الجوال");
                                                    } else if (first_name_controoler
                                                            .text ==
                                                        "") {
//                                                    XsProgressHud.hide();
                                                      Loader.hideDialog(
                                                          context);
                                                      flusher_error(
                                                          "الرجاء ادخال الاسم الاول");
                                                    } else if (last_name__controoler
                                                            .text ==
                                                        "") {
//                                                    XsProgressHud.hide();
                                                      Loader.hideDialog(
                                                          context);
                                                      flusher_error(
                                                          "الرجاء ادخال الاسم الثاني");
                                                    } else if (email_controoler
                                                            .text ==
                                                        "") {
//                                                    XsProgressHud.hide();
                                                      Loader.hideDialog(
                                                          context);
                                                      flusher_error(
                                                          "الرجاء ادخال الايميل");
                                                    } else {
                                                      signup_screen();
                                                    }
                                                  },
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(10.0),
                                                  ),
                                                  color: Color.fromRGBO(
                                                      69, 57, 137, 1.0),
                                                  child: Text(
                                                    "التالي",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                )),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            cardKey.currentState.toggleCard();
                                          },
                                          child: Text(
                                            " تسجيل دخول ",
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    69, 57, 137, 1.0)),
                                          ),
                                        ),
//                                      cardKey.currentState.toggleCard()
                                        GestureDetector(
                                          onTap: () =>
                                              cardKey.currentState.toggleCard(),
                                          child: Text(
                                            "  لديك حساب ؟ ",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Center(
                                child: CircleAvatar(
                              radius: 35,
                              child: Container(
                                  width: 140.0,
                                  height: 140.0,
                                  decoration: new BoxDecoration(
                                    border: Border.all(
                                        width: 4, color: Colors.white),
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                      image: AssetImage("assets/image.png"),
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                              backgroundColor: Color.fromRGBO(69, 57, 137, 1.0),
                            ))
                          ],
                        )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
