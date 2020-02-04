import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:rasseed/utils/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BankTransfer extends StatefulWidget {
  @override
  _BankTransferState createState() => _BankTransferState();
}

class _BankTransferState extends State<BankTransfer> {
  TextEditingController fullName = TextEditingController();
  TextEditingController cardNumber = new TextEditingController();
  TextEditingController amount = new TextEditingController();
  TextEditingController notes = new TextEditingController();

  Color bankColor = Colors.grey.withOpacity(.5);
  Color nameColor = Colors.grey.withOpacity(.5);
  Color cardColor = Colors.grey.withOpacity(.5);
  Color amountColor = Colors.grey.withOpacity(.5);
  Color notesColor = Colors.grey.withOpacity(.5);

  bool bankInput = false;
  bool nameInput = false;
  bool cardInput = false;
  bool amountInput = false;
  bool notesInput = false;

  RassedBankModel selectedRassedBankModel;
  List<RassedBankModel> rassedBankModelList;
  UserBankModel selectedUserBankModel;
  List<UserBankModel> userBankModelList;

  transfer() {
    if (selectedUserBankModel != null) {
      setState(() {
        bankColor = Colors.grey.withOpacity(.5);
        bankInput = true;
      });
    } else {
      setState(() {
        bankColor = Colors.red.withOpacity(.5);
        bankInput = false;
      });
    }/*
    if (bankSelected.isNotEmpty) {
      setState(() {
        bankColor = Colors.grey.withOpacity(.5);
        bankInput = true;
      });
    } else {
      setState(() {
        bankColor = Colors.red.withOpacity(.5);
        bankInput = false;
      });
    }*/

    if (fullName.text.toString().isNotEmpty) {
      setState(() {
        nameColor = Colors.grey.withOpacity(.5);
        nameInput = true;
      });
    } else {
      setState(() {
        nameColor = Colors.red.withOpacity(.5);
        nameInput = false;
      });
    }
    if (cardNumber.text.toString().isNotEmpty) {
      setState(() {
        cardColor = Colors.grey.withOpacity(.5);
        cardInput = true;
      });
    } else {
      setState(() {
        cardColor = Colors.red.withOpacity(.5);
        cardInput = false;
      });
    }
    if (amount.text.toString().isNotEmpty) {
      setState(() {
        amountColor = Colors.grey.withOpacity(.5);
        amountInput = true;
      });
    } else {
      setState(() {
        amountColor = Colors.red.withOpacity(.5);
        amountInput = false;
      });
    }
    if (notes.text.toString().isNotEmpty) {
      setState(() {
        notesColor = Colors.grey.withOpacity(.5);
        notesInput = true;
      });
    } else {
      setState(() {
        notesColor = Colors.red.withOpacity(.5);
        notesInput = false;
      });
    }

    if (notesInput && amountInput && cardInput && nameInput && bankInput) {
      print("valid");
      bank_transfer();
    }
  }

  rassedBankModelsWidget() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Column(
                children: rassedBankModelList.map((rassedModelItem){
                  return ListTile(
                    onTap: (){
                      setState(() {
                        selectedRassedBankModel = rassedModelItem;
                      });
                      Navigator.pop(context);
                    },
                    title: Text(
                    "${rassedModelItem.bankName}",
                    style: TextStyle(
                        color: Color.fromRGBO(69, 57, 137, 1.0), fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  );
                }).toList(),
              )
            ));
  }


  userBankModelsWidget() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                children: userBankModelList.map((rassedModelItem){
                  return ListTile(
                    onTap: (){
                      setState(() {
                        selectedUserBankModel = rassedModelItem;
                      });
                      Navigator.pop(context);
                    },
                    title: Text(
                      "${rassedModelItem.bankName}",
                      style: TextStyle(
                          color: Color.fromRGBO(69, 57, 137, 1.0), fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  );
                }).toList(),
              ),
            )
        ));
  }

  String bankSelected = "";


  Future<String> getUserSID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('\n\n\n user sid: ${prefs.getString('client_auth')}\n\n\n');
    return prefs.getString('client_auth');
  }

  /*

======= to
https://app.rasseed.com/api/method/ash7anly.api.get_bank?_lang=ar&sid=64fc4904519bfe16e91ca4c277fc54fc4de1a4006847176fa76aee13

   */
  Future<String> getRasseedBank(String sid) async {
    Loader.showUnDismissibleLoader(context);

    /// todo endpoint
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(
        "https://www.rasseed.com/api/method/ash7anly.api.get_supported_bank"));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode({"_lang": "ar", "sid": sid})));
    HttpClientResponse response = await request.close();

    print("\n\n status code is: ${response.statusCode}\n\n");

    // todo - you should check the response.statusCode
    String replay = await response.transform(utf8.decoder).join();
    httpClient.close();
    print("\n\n replay: ${replay}\n\n");

    rassedBankModelList =List();
    if (response.statusCode == 200) {
      Loader.hideDialog(context);
      List<dynamic> rassedModels = json.decode(replay)['message'];
      print('\n\ngetRasseedBank body is: ${json.decode(replay)}\n\n');
      print('\n\n getRasseedBank json.decode(replay)[message] is: ${json.decode(replay)['message']}\n\n');
      setState(() {
        rassedModels.forEach((model){
          rassedBankModelList.add(RassedBankModel.fromJson(model));
        });
      });

      if(rassedBankModelList[0]!= null)setState(() {
        selectedRassedBankModel = rassedBankModelList[0];
      });

      print('\n\n getRasseedBank rassedBankModel.bankName: ${rassedBankModelList[0].bankName}\n\n');
    } else {
      Loader.hideDialog(context);
    }
  }

  /*

========= from
  https://www.rasseed.com/api/method/ash7anly.api.get_supported_bank?_lang=ar&sid=64fc4904519bfe16e91ca4c277fc54fc4de1a4006847176fa76aee13

   */
  Future<String> getUserSelectionBank(String sid) async {
    Loader.showUnDismissibleLoader(context);

    /// todo endpoint
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(
        "https://app.rasseed.com/api/method/ash7anly.api.get_bank"));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode({"_lang": "ar", "sid": sid})));
    HttpClientResponse response = await request.close();

    print("\n\n status code is: ${response.statusCode}\n\n");

    // todo - you should check the response.statusCode
    String replay = await response.transform(utf8.decoder).join();
    httpClient.close();
    print("\n\n replay: ${replay}\n\n");
    userBankModelList   =List();
    if (response.statusCode == 200) {
      Loader.hideDialog(context);
      List<dynamic> userBankModels = json.decode(replay)['message'];
      print('\n\ngetRasseedBank body is: ${json.decode(replay)}\n\n');
      print('\n\n getRasseedBank json.decode(replay)[message] is: ${json.decode(replay)['message']}\n\n');
      setState(() {
        userBankModels.forEach((model){
          userBankModelList.add(UserBankModel.fromJson(model));
        });
      });

      if(userBankModelList[0]!= null)setState(() {
        selectedUserBankModel = userBankModelList[0];
      });

      print('\n\n getRasseedBank rassedBankModel.bankName: ${userBankModelList[0].bankName}\n\n');
    } else {
      Loader.hideDialog(context);
    }
  }

  Future<String> bank_transfer() async {
    Loader.showUnDismissibleLoader(context);

    print("bank_transfer");
    String fullName_ = fullName.text;
    String amount_ = amount.text;
    String notes_ = notes.text;
    String cardNumber_ = cardNumber.text;

    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse("https://www.rasseed.com/api/resource/Bank Payment"));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(

//        {
//          "data": "{\"bank\":\"f92ebcb7c8\",\"fullname\":\"$fullName_\",\"account_number\":\"$cardNumber_\",\"amount\":\"$amount_\",\"workflow_state\":\"Pending\",\"status\":\"pending\",\"supported_bank\":\"da5694645f\"}",
//          "sid": "64fc4904519bfe16e91ca4c277fc54fc4de1a4006847176fa76aee13"
//        }

        {
          "data": "{\"bank\":\"4e6e73616d\",\"fullname\":\"basma 555 test\",\"account_number\":\"2588774555\",\"amount\":\"250\",\"workflow_state\":\"Pending\",\"status\":\"pending\",\"supported_bank\":\"da5694645f\"}",
          "sid": "64fc4904519bfe16e91ca4c277fc54fc4de1a4006847176fa76aee13"
        }

    )));
    HttpClientResponse response = await request.close();

    print("\n\n status code is: ${response.statusCode}\n\n");

    // todo - you should check the response.statusCode
    String replay = await response.transform(utf8.decoder).join();

    print("\n\n status code is: ${response.statusCode}\n\n");
    print("\n\n bank_transfer replay is: $replay\n\n");

  }

  @override
  void initState() {
    super.initState();
    getUserSID().then((savedSID) {
      getRasseedBank(savedSID);
      getUserSelectionBank(savedSID);
    });
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Color.fromRGBO(69, 57, 137, 1.0));
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color.fromRGBO(69, 57, 137, 1.0),
        centerTitle: true,
        title: Text(
          "تحويل بنكى",
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20.0),
                alignment: Alignment.centerRight,
                child: Text(
                  "من بطاقه",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(69, 57, 137, 1.0),
                      fontSize: 18),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: .5,
                color: Colors.grey.withOpacity(.5),
              ),
              Container(
                margin:
                    EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 7),
                alignment: Alignment.centerRight,
                child: Text(
                  "البنك",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(69, 57, 137, 1.0),
                      fontSize: 15),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: bankColor)),
                child: Container(
                  margin: EdgeInsets.only(left: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: IconButton(
                            icon: Icon(
                              Icons.arrow_drop_down,
                              size: 20,
                            ),
                            onPressed: () {
                              userBankModelsWidget();
                            }),
                      ),
                      Container(
                        child: Text(
                          "${selectedUserBankModel!= null ? selectedUserBankModel.bankName: ''}",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 7),
                alignment: Alignment.centerRight,
                child: Text(
                  "الاسم كامل",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(69, 57, 137, 1.0),
                      fontSize: 15),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: nameColor)),
                child: Container(
                  margin: EdgeInsets.only(left: 10.0),
                  child: TextField(
                    onChanged: (_) {
                      setState(() {
                        nameColor = Colors.grey.withOpacity(.5);
                      });
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    controller: fullName,
                    textDirection: TextDirection.rtl,
                    keyboardAppearance: Brightness.light,
                    cursorRadius: Radius.circular(15.0),
                    keyboardType: TextInputType.text,
                    autocorrect: true,
                  ),
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 7),
                alignment: Alignment.centerRight,
                child: Text(
                  "رقم البطاقه",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(69, 57, 137, 1.0),
                      fontSize: 15),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: cardColor)),
                child: Container(
                  margin: EdgeInsets.only(left: 10.0),
                  child: TextField(
                    onChanged: (_) {
                      setState(() {
                        cardColor = Colors.grey.withOpacity(.5);
                      });
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    controller: cardNumber,
                    textDirection: TextDirection.ltr,
                    keyboardAppearance: Brightness.light,
                    cursorRadius: Radius.circular(15.0),
                    keyboardType: TextInputType.text,
                    autocorrect: true,
                  ),
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 7),
                alignment: Alignment.centerRight,
                child: Text(
                  "المبلغ",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(69, 57, 137, 1.0),
                      fontSize: 15),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: amountColor)),
                child: Container(
                  margin: EdgeInsets.only(left: 10.0),
                  child: TextField(
                    onChanged: (_) {
                      setState(() {
                        amountColor = Colors.grey.withOpacity(.5);
                      });
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    controller: amount,
                    textDirection: TextDirection.ltr,
                    keyboardAppearance: Brightness.light,
                    cursorRadius: Radius.circular(15.0),
                    keyboardType: TextInputType.text,
                    autocorrect: true,
                  ),
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 7),
                alignment: Alignment.centerRight,
                child: Text(
                  "ملاحظات",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(69, 57, 137, 1.0),
                      fontSize: 15),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: notesColor)),
                child: Container(
                  margin: EdgeInsets.only(left: 10.0),
                  child: TextField(
                    onChanged: (_) {
                      setState(() {
                        notesColor = Colors.grey.withOpacity(.5);
                      });
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    controller: notes,
                    textDirection: TextDirection.rtl,
                    keyboardAppearance: Brightness.light,
                    cursorRadius: Radius.circular(15.0),
                    keyboardType: TextInputType.text,
                    autocorrect: true,
                  ),
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 7),
                alignment: Alignment.centerRight,
                child: Text(
                  "الى بطاقة",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(69, 57, 137, 1.0),
                      fontSize: 15),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: .5,
                color: Colors.grey.withOpacity(.5),
              ),
              Container(
                margin:
                    EdgeInsets.only(right: 20, left: 20, top: 15, bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    InkWell(
                      onTap:  () {
                        rassedBankModelsWidget();
                      },
                      child: Container(
                          child: Text(
                        "تغير",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(69, 57, 137, 1.0)),
                      )),
                    ),
                    Container(
                        child: Text(
                      "${selectedRassedBankModel!= null ? selectedRassedBankModel.bankName:''}",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 17),
                    )),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 0),
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                        "${selectedRassedBankModel!= null ? selectedRassedBankModel.name:''}",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(69, 57, 137, 1.0),
                            fontSize: 14)),
                    Text(" : ",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(69, 57, 137, 1.0),
                            fontSize: 14)),
                    Text("اسم الحساب",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(69, 57, 137, 1.0),
                            fontSize: 14)),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 0),
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                        "${selectedRassedBankModel!= null ? selectedRassedBankModel.accountNumber:''}",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(69, 57, 137, 1.0),
                            fontSize: 14)),
                    Text(" : ",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(69, 57, 137, 1.0),
                            fontSize: 14)),
                    Text("رقم الحساب",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(69, 57, 137, 1.0),
                            fontSize: 14)),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 0),
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                        "${selectedRassedBankModel!= null ? selectedRassedBankModel.i_ban:''}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(69, 57, 137, 1.0),
                            fontSize: 14)),
                    Text(" : ",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(69, 57, 137, 1.0),
                            fontSize: 14)),
                    Text("رقم الحساب المصرفى",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(69, 57, 137, 1.0),
                            fontSize: 14)),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    transfer();
                  },
                  highlightColor: Colors.white,
                  splashColor: Colors.white,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3,
                    height: 35,
                    margin: EdgeInsets.only(top: 30, bottom: 15.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(69, 57, 137, 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Text(
                      "تحويل",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w400),
                    ),
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

class RassedBankModel {
  final String bankName;
  final String i_ban;
  final String accountName;
  final String name;
  final String accountNumber;

/*
{
    "message": [
        {
            "bank_name": "مصرف الراجحي",
            "i_ban": "SA02 8000 0599 6080 1008 8893",
            "account_name": " شركة بطاقة الشبكة لتقنية المعلومات",
            "name": "da5694645f",
            "account_number": "599608010088893"
        }
    ]
}
 */
  RassedBankModel({
    this.bankName,
    this.i_ban,
    this.accountName,
    this.name,
    this.accountNumber,
  });

  /// todo remove specifying index to add change functionality
  factory RassedBankModel.fromJson(dynamic json) => RassedBankModel(
        bankName: json['bank_name'],
        i_ban: json['i_ban'],
        accountName: json['account_name'],
        name: json['name'],
        accountNumber: json['account_number'],
      );
}

class UserBankModel {
  final String bankName;
  final String accountName;
  final String name;
  final String accountNumber;

/*
{
    "message": [
        {
            "bank_name": "البنك السعودي للاستثمار",
            "account_name": "",
            "name": "4e6e73616d",
            "account_number": null
        },
    ]
}
 */
  UserBankModel({
    this.bankName,
    this.accountName,
    this.name,
    this.accountNumber,
  });

  /// todo remove specifying index to add change functionality
  factory UserBankModel.fromJson(dynamic json) => UserBankModel(
        bankName: json['bank_name'],
        accountName: json['account_name'],
        name: json['name'],
        accountNumber: json['account_number'],
      );
}
