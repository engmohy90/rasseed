import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rasseed/screens/my_cards/my_cards.dart';
import 'package:rasseed/utils/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransferCard extends StatefulWidget {
  TransferCard(this.cardsData);

  final Map<String, dynamic> cardsData;

  @override
  _TransferCardState createState() => _TransferCardState();
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
class _TransferCardState extends State<TransferCard> {
  bool isExpanded = false;
  bool isSending = false;
  int cardsNumber;

  Map<String, dynamic> card;

  GlobalKey<ScaffoldState> shopCartGlobalKey = GlobalKey();
  TextEditingController cardsQuantityController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  cardTransferAlert(StateSetter setter) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter state) => AlertDialog(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          content: Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height / 3,
            child: Container(
              height: (MediaQuery.of(context).size.height / 100) * 40,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      InkWell(
                        child: Icon(Icons.close),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      Expanded(
                        child: Text('حالة الطلب', textAlign: TextAlign.center,),
                      )
                    ],
                  ),


                  Container(
                    color: Colors.grey,
                    width: MediaQuery.of(context).size.width,
                    height: 2,
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.tag_faces, size: 50,),
                      Text(
                        'تم التحويل',
                        style: TextStyle(
                            color: Color.fromRGBO(69, 57, 137, 1.0),
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'تم تحويل كود الشحن بنجاح الى الرقم',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '${phoneController.text ?? '000'}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromRGBO(69, 57, 137, 1.0),
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  transferringAlert(StateSetter setter) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter state) => AlertDialog(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          content: Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height / 3,
            child: Container(
              height: (MediaQuery.of(context).size.height / 100) * 40,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    'سيتم تحويل كود الشحن عبر رسالة نصيه',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),

                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'SAR',
                          style: TextStyle(
                              color: Color.fromRGBO(69, 57, 137, 1.0),
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '${card['value'] ?? '0'}',
                          style: TextStyle(
                              color: Color.fromRGBO(69, 57, 137, 1.0),
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('بطاقة'),
                      ],
                    ),
                  ),
                  Text(
                    'الى رقم الجوال',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  Text(
                    '${phoneController.text ?? '000'}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color.fromRGBO(69, 57, 137, 1.0),
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      InkWell(
                        child: Text('تحويل'),
                        onTap: () {
                          RegExp exp = new RegExp(r"(^[5]\d{8})");
                          String str = phoneController.text;
                          bool phone_exp = exp.hasMatch(str);

                          if (phone_exp == false)
                            shopCartGlobalKey.currentState
                                .showSnackBar(SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(
                                'رقم الهاتف يجب أن يكون 9 أرقام ويبدأ برقم 5، مثال: 598765432',
                                textAlign: TextAlign.center,
                              ),
                            ));
                          else{
//                            Loader.hideDialog(context);
                            Loader.showUnDismissibleLoader(context);
                            getUserSID().then((savedSID) {
                              transferCard(
                                  sid: savedSID,
                                  cardName: card['namecard'],
                                  toUserPhone: phoneController.text)
                                  .then((transferringCardStatus) {
                                print(
                                    '\n\nbody is phoneController.text: ${phoneController.text}\n\n');
                                print('\n\nbody is pin: ${card['pin']}\n\n');
                                if (transferringCardStatus == 'success') {
                                  Loader.hideDialog(context);
                                  Loader.hideDialog(context);
                                  cardTransferAlert(setState);
                                } else if (transferringCardStatus == 'failed') {
                                  Loader.hideDialog(context);
                                  Loader.hideDialog(context);
                                  shopCartGlobalKey.currentState
                                      .showSnackBar(SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      'حدثت مشكلة اثناء تحويل الكارت برجاء المحاولة مرة اخرى!',
                                      textAlign: TextAlign.center,
                                    ),
                                  ));
                                  Timer(Duration(seconds: 2), () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => My_cards()));
                                  });
                                } else {
                                  Navigator.pop(context);

                                  shopCartGlobalKey.currentState
                                      .showSnackBar(SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      '$transferringCardStatus',
                                      textAlign: TextAlign.center,
                                    ),
                                  ));
                                }
                              });
                            });
                          }
                        },
                      ),
                      Container(
                        color: Colors.grey,
                        width: 2,
                        height: 20,
                      ),
                      InkWell(
                        child: Text('تغيير الرقم'),
                        onTap: () => Navigator.pop(context),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String> getUserSID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString('client_auth');
  }

  Future<String> getUserPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString('phone');
  }


  Future<String> transferCard({
    String sid,
    String cardName,
    int quantity,
    String fromUserPhone,
    String toUserPhone,
  }   ) async {
    Loader.showUnDismissibleLoader(context);

    /// todo endpoint
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(
        Uri.parse("https://www.rasseed.com/api/resource/resource/Transfer"));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode({
      "sid": sid,
      "data": {
        "from_user": fromUserPhone,
        "to_user": toUserPhone,
        "transfer_details": [
          {"quantity": quantity ?? 1, "card": cardName}
        ]
      },
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
      if(json.decode(replay)['message'] == null)return 'success';
      else return json.decode(replay)['message'];
    } else {
      Loader.hideDialog(context);
      // error
      return 'failed';
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      card = widget.cardsData;

      print('\n\ncardcardcard : $card\n\n');
      print('\n\n widget.cardsDatawidget.cardsData : ${widget.cardsData}\n\n');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: shopCartGlobalKey,
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(69, 57, 137, 1.0),
        centerTitle: true,
        title: Text(
          'تحويل كود الشحن',
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
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: (MediaQuery.of(context).size.height / 100) * 85,
          margin: EdgeInsets.only(
            top: 25.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Card(
                elevation: 5.0,
                margin: EdgeInsets.only(left: 15.0, right: 15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
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
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'SAR',
                                style: TextStyle(
                                    color: Color.fromRGBO(69, 57, 137, 1.0),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                '${card['value'] ?? '0'}',
                                style: TextStyle(
                                    color: Color.fromRGBO(69, 57, 137, 1.0),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'بطاقه',
                                style: TextStyle(
                                    color: Color.fromRGBO(69, 57, 137, 1.0),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                '1',
                                style: TextStyle(
                                    color: Color.fromRGBO(69, 57, 137, 1.0),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.indigo,
//                  height: 130.0,
                  margin: EdgeInsets.only(top: 20.0),
                  width: (MediaQuery.of(context).size.width / 100) * 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'عدد البطاقات المراد تحويلها',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      Card(
                        margin: EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 10),
                        elevation: 0,
                        color: Colors.white,
                        shape: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.2),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: Container(
                          height: 40,
                          child:
                          TextField(
                            controller: cardsQuantityController,
                            autofocus: false,
                            textAlign: TextAlign.center,
                            focusNode: FocusNode(),
                            style: TextStyle(fontSize: 14),
                            maxLines: 1,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "0",
                              border: InputBorder.none,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        'رقم الجوال',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      Card(
                        margin: EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 10),
                        elevation: 0,
                        color: Colors.white,
                        shape: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.2),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: Container(
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              CountryCodePicker(
                                onChanged: (print) {
//                                            _dialCode = print.dialCode;
                                },
                                textStyle: TextStyle(fontSize: 12),
                                initialSelection: 'SA',
                                favorite: ['+966', 'SA'],
                                showCountryOnly: true,
                                showFlag: false,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5, bottom: 5),
                                child: Container(
                                  width: 2,
                                  height: 40,
                                  color: Colors.grey.withOpacity(0.1),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 0),
                                  child: TextField(
                                    controller: phoneController,
                                    autofocus: false,
                                    textAlign: TextAlign.center,
                                    focusNode: FocusNode(),
                                    style: TextStyle(fontSize: 14),
                                    maxLines: 1,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      hintText: "ادخل رقم الجوال",
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        'يجب ان يكون مسجل برصيد',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      InkWell(
                        onTap: () {
                          RegExp exp = new RegExp(r"(^[5]\d{8})");
                          String str = phoneController.text;
                          bool phone_exp = exp.hasMatch(str);
print('\n\n cardsQuantityController.text :: ${cardsQuantityController.text.length}\n\n');
                          if (cardsQuantityController.text.length == 0)
                            shopCartGlobalKey.currentState
                                .showSnackBar(SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(
                                'برجاء تحديد عدد البطاقات المراد تحويلها',
                                textAlign: TextAlign.center,
                              ),
                            ));


                          else if (phone_exp == false)
                            shopCartGlobalKey.currentState
                                .showSnackBar(SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(
                                'رقم الهاتف يجب أن يكون 9 أرقام ويبدأ برقم 5، مثال: 598765432',
                                textAlign: TextAlign.center,
                              ),
                            ));
                          else
                            transferringAlert(setState);
                        },
                        child: Container(
                          height: 40,
                          width:
                              (MediaQuery.of(context).size.width / 100) * 100,
                          margin: EdgeInsets.only(
                              left: 20, right: 20, top: 10, bottom: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            ),
                            color: Color.fromRGBO(69, 57, 137, 1.0),
                          ),
                          child: Text(
                            'تحويل',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Text(
                        'سيتم تحويل كود الشحن عبر رسالة نصيه',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
