import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:rasseed/screens/Home_screen.dart';
import 'package:rasseed/screens/my_cards/ZainCard.dart';
import 'package:rasseed/utils/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';

class verfiy_login extends StatefulWidget {
  verfiy_login(this.phoneNumber,{ this.isAnonymous, this.operatorID});

  final String phoneNumber;
  final bool isAnonymous;
  final String operatorID;

  @override
  _verfiy_loginState createState() => _verfiy_loginState();
}

class _verfiy_loginState extends State<verfiy_login> {
  GlobalKey<ScaffoldState> verifyLoginKey = GlobalKey();
  String _dialCode = "";

//  TextEditingController phone_controoler = TextEditingController();
  int valuechanged = 0;

  var finalresult = 0.0;

  GlobalKey pinAutoFillKey;

  void valuechangedfunc(int value) {
    setState(() {
      valuechanged = value;
      if (valuechanged == 0) {
      } else if (valuechanged == 1) {}
    });
  }

  void addValueToShared({String key, String value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

//  int timer = 5;
  bool resend = false;
  Timer _everySecond;

  Future<String> performLogin(BuildContext context,
      {String pushToken, String phoneNumber, String verificationCode}) async {
    Loader.showUnDismissibleLoader(context);

    print('\n\n verificationCode: $verificationCode\n\n');
//      if (_dialCode.length > 0) {
    /// todo endpoint
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(
        "https://app.rasseed.com/api/method/ash7anly.auth1.activate"));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode({
      "phone": widget.phoneNumber, // "510922408"
      "code": verificationCode, // "2346"
      "push_token": "kkkkkkkkkk", // pushToken
      "system": Platform.isAndroid ? 'android' : "ios"
    })));
    HttpClientResponse response = await request.close();

    print("\n\n${response.statusCode}dssaaadxxsd\n\n");

    // todo - you should check the response.statusCode
    String replay = await response.transform(utf8.decoder).join();
    Map<String, dynamic> dataMap = json.decode(replay);
    httpClient.close();
    print("\n\n${replay}dssaaadxxsd\n\n");

    Loader.hideDialog(context);
    print("ggggg${response.statusCode}");
    if (response.statusCode == 200) {
      addValueToShared(
        key: 'phonecode',
        value: dataMap['phonecode'],
      );
      addValueToShared(
        key: 'banner_image_for_mobile',
        value: dataMap['banner_image_for_mobile'],
      );
      addValueToShared(
        key: 'number_point',
        value: dataMap['number_point'],
      );
      addValueToShared(
        key: 'code_mandoob',
        value: dataMap['code_mandoob'],
      );
      addValueToShared(
        key: 'min_amount_bank_transfer',
        value: dataMap['min_amount_bank_transfer'],
      );
      addValueToShared(
        key: 'home_page',
        value: dataMap['home_page'],
      );
      addValueToShared(
        key: 'client_auth',
        value: dataMap['sid'],
      );
      addValueToShared(
        key: 'user_image',
        value: dataMap['user_data']['user_image'],
      );
      addValueToShared(
        key: 'email_2',
        value: dataMap['email_2'],
      );
      addValueToShared(
        key: 'phone',
        value: dataMap['phone'],
      );
      addValueToShared(
        key: 'account_bank_number',
        value: dataMap['account_bank_number'],
      );
      addValueToShared(
        key: 'full_name',
        value: dataMap['full_name'],
      );
      addValueToShared(
        key: 'country_name',
        value: dataMap['country_name'],
      );
      addValueToShared(
        key: 'tier',
        value: dataMap['tier'],
      );
      addValueToShared(
        key: 'message',
        value: dataMap['message'],
      );
      addValueToShared(
        key: 'tried_code_mandoob',
        value: dataMap['tried_code_mandoob'].toString(),
      );
      addValueToShared(
        key: 'email',
        value: dataMap['email'],
      );
      Timer(
          Duration(seconds: 1),
          () => widget.isAnonymous == false? Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home_screen())):{
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Home_screen())),
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => ZienCard(operatorID: widget.operatorID,)))
          });
    } else {
      print('\n\n response; ${response.statusCode}\n\n');
      print('\n\njson ${json.decode(replay)['message']}\n\n');
      verifyLoginKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Container(  width: MediaQuery.of(context).size.width,child: Text('الرمز المدخل غير صحيح برجاء التأكد من الرمز و إعادة المحاولة',textAlign: TextAlign.center,)),
      ));
    }
    return "done";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    _everySecond = Timer.periodic(Duration(seconds: 1), (Timer t) {
//      if (!mounted) return;
//      if (timer > 0) {
//        setState(() {
//          timer--;
//          resend = false;
//        });
//      } else if (resend) {
//        setState(() {
//          timer = 5;
//        });
//      }
//    });

    pinAutoFillKey = GlobalKey();
    () async => await SmsAutoFill().listenForCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: verifyLoginKey,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(69, 57, 137, 1.0),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(40.0),
                    bottomLeft: Radius.circular(40.0)),
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
                    Container(
                        child: Text("تسجيل دخول",
                            style:
                                TextStyle(color: Colors.white, fontSize: 24)),
                        alignment: Alignment.centerRight)
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
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: 50.0, right: 20.0),
                                        child: Text(
                                          "أدخل الرمز المرسل إليك عبر جوالك",
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black),
                                        ),
                                      ),

                                      ///todo PinFieldAutoFill
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 60.0, right: 60.0),
                                        child: PinFieldAutoFill(
                                          codeLength: 4,
                                          currentCode: _dialCode,
                                          key: pinAutoFillKey,
                                          autofocus: true,
                                          onCodeChanged: (value) {
                                            if (value.length == 4)
                                              performLogin(context,
                                                  verificationCode: value);
                                          },
                                          decoration: UnderlineDecoration(
                                              textStyle: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black)),
                                        ),
                                      ),
//                                          Container(
//                                            alignment: Alignment.center,
//                                            margin: EdgeInsets.only(top: 40.0),
//                                            child: Text(" ${timer
//                                                .toString()} سيعاد ارسال الرمز بعد",
//                                              style: TextStyle(fontSize: 15.0,
//                                                  color: Colors.grey
//                                                      .withOpacity(.5)),),
//                                          ),
//
//
//                                          RaisedButton(
//                                            child: Text('Confirm'),
//                                            onPressed: () async =>performLogin(),
//                                          ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 50),
                              ),
                            ],
                          ),
                        ),
                        Center(
                            child: CircleAvatar(
                          radius: 35,
                          child: Container(
                            alignment: Alignment.center,
                            width: 140.0,
                            height: 140.0,
                            decoration: new BoxDecoration(
                              border: Border.all(width: 4, color: Colors.white),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.lock,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
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
    );
  }
}
