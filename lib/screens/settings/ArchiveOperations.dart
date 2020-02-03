import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:rasseed/functions/shared_services.dart';
import 'package:rasseed/utils/center_loader.dart';
import 'package:rasseed/utils/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ArchiveOperations extends StatefulWidget {
  @override
  _ArchiveOperationsState createState() => _ArchiveOperationsState();
}

/// todo add filter operations
class _ArchiveOperationsState extends State<ArchiveOperations> {
  String selectedFilter;
  List<dynamic> buyingOperationList = List();
  List<dynamic> chargeLogList = List();
  List<dynamic> mainTransferLogList = List();
  List<dynamic> transferToLogList = List();
  List<dynamic> transferFromLogList = List();

  String buyingOperation = "عمليات الشراء";
  String chargeOperation = "عمليات الشحن";
  String transferFromOperation = "التحويل من";
  String transferToOperation = "التحويل الى";

  String bank = "بنكي";
  String visa = "فيزا";
  String mada = "مدا";
  String rasseed = "رصيد";

  String tempSelected;
  String userEmail;

  showLangList() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        content: Container(
          height: MediaQuery.of(context).size.height / 1.7,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 15.0),
                child: Text(
                  "تغير الفئه",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15.0),
                child: Text(
                  "حدد الفئه التى ترغب بعرضها؟",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.only(top: 15.0),
                child: RadioButtonGroup(
                    activeColor: Color.fromRGBO(69, 57, 137, 1.0),
                    labels: <String>[
                      chargeOperation,
                      buyingOperation,
                      transferFromOperation,
                      transferToOperation,
                    ],
                    onSelected: (String selected) {
                      setState(() {
                        tempSelected = selected;
                        print('\n\n selectedFilter is: $selectedFilter\n\n');
                      });
                    }),
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
                          setState(() {

                            selectedFilter = tempSelected;
                          });
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "تغير",
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

  buyingWidget(List<dynamic> itemsList) {
    return GridView.builder(
        itemCount: itemsList.length,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 5.0, crossAxisSpacing: 5.0),
        itemBuilder: (context, index) {
          print('\n\n\nitemsList[index][value] :: ${itemsList[index]['value']}\n\n');

          /// todo update ui
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
                              "https://www.rasseed.com${itemsList[index]['logo']}"),
                        ),
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          children: <Widget>[
                            Text(
                              "رس",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(width: 2,),
                            Text(
                              '${itemsList[index]['value']}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          children: <Widget>[
                            Text(
                              'بطاقه',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(width: 2,),
                            Text(
                              '${itemsList[index]["quantity"]}',
                              textAlign: TextAlign.center,
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
                ],
              ),
            ),
          );
        });
  }

  chargeLogWidget() {
    return ListView.builder(
        itemCount: chargeLogList.length,
//        physics: NeverScrollableScrollPhysics(),
//        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//            crossAxisCount: 2, mainAxisSpacing: 5.0, crossAxisSpacing: 5.0),
        itemBuilder: (context, index) {
          print(
              '\n\n\nitemsList[index][value] :: ${chargeLogList[index]['value']}\n\n');

          return Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: Color.fromRGBO(69, 57, 137, .1),
                    borderRadius: BorderRadius.all(
                        Radius.circular(10.0))),
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                height: 40.0,
                margin: EdgeInsets.only(
                    right: 20.0, left: 20.0, top: 25),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    /// todo from user
//                    Container(
//                      margin: EdgeInsets.only(right: 20.0),
//                      child: Text(
//                        'نوع الدفع: ',
//                        style: TextStyle(
//                            fontSize: 15,
//                            fontWeight: FontWeight.w300,
//                            color: Colors.black),
//                      ),
//                    ),
                    Container(
                      margin: EdgeInsets.only(right: 10.0),
                      child: Text(
                        'تاريخ الشحن: '
                            '${chargeLogList[index]['charge_date'] != null ? chargeLogList[index]['charge_date'].toString().substring(0, 10) : 'غير معروف'}',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                            color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 20.0),
                  height:chargeLogList.length*
                      (MediaQuery.of(context)
                          .size
                          .height /
                          20),
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 18,
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
                                      "https://www.rasseed.com${chargeLogList[index]['logo']}"),
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
                            margin: EdgeInsets.only(left: 10.0, right: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  '${chargeLogList[index]['value']} رس ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                      "${chargeLogList[index]["from_user"]["full_name"]}  :من ",
                                  textAlign: TextAlign.center,
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
                  )),
            ],
          );
        });
  }

  transferFromWidget(List<dynamic> itemsList) {
    return GridView.builder(
        itemCount: itemsList.length,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 5.0, crossAxisSpacing: 5.0),
        itemBuilder: (context, index) {
          print('\n\n\nitemsList[index][value] :: ${itemsList[index]['value']}\n\n');

          /// todo update ui
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
                              "https://www.rasseed.com${itemsList[index]['logo']}"),
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
                    child: Text(
                      '${itemsList[index]['value']}'
                          "رس",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  transferToWidget (List<dynamic> itemsList) {
    return GridView.builder(
        itemCount: itemsList.length,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 5.0, crossAxisSpacing: 5.0),
        itemBuilder: (context, index) {
          print('\n\n\nitemsList[index][value] :: ${itemsList[index]['value']}\n\n');

          /// todo update ui
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
                              "https://www.rasseed.com${itemsList[index]['logo']}"),
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
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              '${itemsList[index]['value']}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              "رس",
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
                              'كرت',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '${itemsList[index]['quantity']}',
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

  Future<String> getUserSID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('\n\n\n user sid: ${prefs.getString('client_auth')}\n\n\n');
    return prefs.getString('client_auth');
  }

/*
  [
      {
            "is_bank": 0,
            "creation": "2019-12-29 13:54:20.544493",
            "is_sadad": 0,
            "owner": "505632750@ash7anly.sa",
            "is_mada": 0,
            "archived": 0,
            "name": "ed68c8c1d1",
            "items": [
                {
                    "name": "e4e5cbcbda",
                    "parent": "ed68c8c1d1",
                    "value": 21.0,
                    "printer_logo": "/files/Webp.net-compress-image.jpg",
                    "logo": "/files/stc.png",
                    "card": "STC Recharge 21 Card",
                    "quantity": 1
                }
            ],
            "order_status": "open",
            "requests": [],
            "is_visa": 1
        },
    ]
 */
  Future<String> getBuyingOperationList(String sid) async {
    Loader.showUnDismissibleLoader(context);
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(
        "https://app.rasseed.com/api/method/ash7anly.api.myorders_payfort?"));
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
      setState(() {
        buyingOperationList = json.decode(replay)['message'];
      });
    } else {
      Loader.hideDialog(context);
    }

    print('\n\n operation list : $buyingOperationList \n\n');
    print('\n\n operation list length: ${buyingOperationList.length}\n\n');
  }

  /*
        "charge_log": [
            {
                "name": "4a510bcbdc",
                "printer_logo": "/files/zain.jpg",
                "creation": "2019-12-12 23:34:35.627547",
                "value": 20.0,
                "to_user": "505632750",
                "user": "505632750@ash7anly.sa",
                "charged_to": "505632750",
                "from_user": {
                    "username": "username505632750",
                    "name": "505632750@ash7anly.sa",
                    "user_type": "Website User",
                    "phone": "505632750",
                    "full_name": "Bama maher",
                    "email": "505632750@ash7anly.sa"
                },
                "logo": "/files/zain1.png",
                "charge_date": "2019-12-12",
                "card": "Zain Recharge 20 Card"
            },
         ],

        "transfer_log": [
            {
                "name": "676211f104",
                "items": [
                    {
                        "name": "ff040575a9",
                        "parent": "676211f104",
                        "value": 16.0,
                        "printer_logo": "/files/Webp.net-compress-image.jpg",
                        "logo": "/files/stc.png",
                        "card": "STC Recharge 16 Card",
                        "quantity": 1
                    }
                ],
                "creation": "2019-07-31 20:42:50.748471",
                "to_user": {
                    "username": "username505632750",
                    "name": "505632750@ash7anly.sa",
                    "user_type": "Website User",
                    "phone": "505632750",
                    "full_name": "Bama maher",
                    "email": "505632750@ash7anly.sa"
                },
                "from_user": {
                    "username": "username505632750",
                    "name": "505632750@ash7anly.sa",
                    "user_type": "Website User",
                    "phone": "505632750",
                    "full_name": "Bama maher",
                    "email": "505632750@ash7anly.sa"
                },
                "owner": "505632750@ash7anly.sa"
            },
         ]
 */
  Future<String> getChargeAndTransferOperationList(String sid) async {
    Loader.showUnDismissibleLoader(context);
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(
        "https://app.rasseed.com/api/method/ash7anly.api.transfers_log?"));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode({"sid": "44b9eb380358b39040a1187ee0d2e431463c40a3a8486687baee7ee7"})));
//    request.add(utf8.encode(json.encode({"sid": sid})));
    HttpClientResponse response = await request.close();

    print("\n\n status code is: ${response.statusCode}\n\n");

    // todo - you should check the response.statusCode
    String replay = await response.transform(utf8.decoder).join();
    httpClient.close();
    print("\n\n replay: ${replay}\n\n");

    if (response.statusCode == 200) {
      Loader.hideDialog(context);
      print(
          '\n\nbody charge_log is: ${json.decode(replay)['message']['charge_log']}\n\n');
      print(
          '\n\nbody transfer_log is: ${json.decode(replay)['message']['transfer_log']}\n\n');
      setState(() {
        chargeLogList = json.decode(replay)['message']['charge_log'];
        mainTransferLogList = json.decode(replay)['message']['transfer_log'];
      });


      setState(() {
        if(mainTransferLogList != null) {
          mainTransferLogList.forEach((mainTransferItem){
            if(mainTransferItem["to_user"]["name"] == userEmail)
              transferFromLogList.add(mainTransferItem);
            else transferToLogList.add(mainTransferItem);
          });
        }
      });
    } else {
      Loader.hideDialog(context);
    }

    print('\n\n chargeLogList list : $chargeLogList \n\n');
    print('\n\n chargeLogList list length: ${chargeLogList.length}\n\n');
    print('\n\n transferLogList list : $mainTransferLogList \n\n');
    print(
        '\n\n transferLogList list length: ${mainTransferLogList.length}\n\n');
  }

  @override
  void initState() {
    super.initState();

    getUserEmail().then((savedEmail){
      if(savedEmail != null)
        setState(() {
          userEmail = savedEmail;
        });
    });
    getUserSID().then((savedSID) {
      getBuyingOperationList(savedSID).then((l) {
        print(
            '\n\n\n user OperationList {operationsList.length: ${buyingOperationList.length}\n\n\n');
      });
    });
    getUserSID().then((savedSID) {
      getChargeAndTransferOperationList(savedSID).then((l) {
        print('\n\n\n user getChargeAndTransferOperationList: }\n\n\n');
      });
    });
    // setting the first and initial list
    setState(() {
      selectedFilter = buyingOperation;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(69, 57, 137, 1.0),
        centerTitle: true,
        title: Text(
          "أرشيف العمليات",
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
        elevation: 0.0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: IconButton(
                        icon: Icon(Icons.search,
                            size: 25, color: Color.fromRGBO(69, 57, 137, 1.0)),
                        onPressed: () {
                          showLangList();
                        },
                      ),
                    ),
                    Container(
                      child: Text(
                        '${selectedFilter ?? ''}',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 10.0),
                height: .5,
                color: Colors.grey.withOpacity(.5),
              ),
              if (selectedFilter ==
                  buyingOperation) // ignore: sdk_version_ui_as_code
                Container(
                  height: MediaQuery.of(context).size.height -
                      (MediaQuery.of(context).size.height / 4),
                  child: buyingOperationList != null
                      ? buyingOperationList.length > 0
                          ? ListView.builder(
                              itemCount: buyingOperationList.length,
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).size.height / 25),
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                            color:
                                                Color.fromRGBO(69, 57, 137, .1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                        alignment: Alignment.center,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 40.0,
                                        margin: EdgeInsets.only(
                                            right: 20.0, left: 20.0, top: 25),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            Container(
                                              margin:
                                                  EdgeInsets.only(right: 20.0),
                                              child: Text(
                                                'نوع الدفع: '
                                                '${buyingOperationList[index]['is_bank'] == 1 ? bank : buyingOperationList[index]["is_sadad"] == 1 ? rasseed : buyingOperationList[index]["is_mada"] == 1 ? mada : buyingOperationList[index]["is_visa"] == 1 ? visa : 'غير معروف'}',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w300,
                                                    color: Colors.black),
                                              ),
                                            ),
                                            Container(
                                              margin:
                                                  EdgeInsets.only(right: 10.0),
                                              child: Text(
                                                'تاريخ الطلب: '
                                                '${buyingOperationList[index]['creation'] != null ? buyingOperationList[index]['creation'].toString().substring(0, 10) : 'غير معروف'}',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w300,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(top: 20.0),
                                          height: buyingOperationList[index]
                                                              ['items']
                                                          .length %
                                                      2 ==
                                                  0
                                              ? ((buyingOperationList[index]
                                                              ['items']
                                                          .length /
                                                      2) *
                                                  (MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      3.2))
                                              : (buyingOperationList[index]['items']
                                                      .length *
                                                  (MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      3.2)),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: selectedFilter == buyingOperation
                                              ? buyingWidget(buyingOperationList[index]['items'])
                                              : Container(height: 100)),
                                    ],
                                  ),
                                );
                              },
                            )
                          : Container(
                              child: Center(
                                child: Text('لا يوجد بيانات لعرضها!'),
                              ),
                            )
                      : CenterCircularLoader(),
                )
              else if (selectedFilter == chargeOperation)
                Container(
                  height: MediaQuery.of(context).size.height -
                      (MediaQuery.of(context).size.height / 4),
                  child: chargeLogList != null
                      ? chargeLogList.length > 0
                          ? chargeLogWidget()
                          : Container(
                              child: Center(
                                child: Text('لا يوجد بيانات لعرضها!'),
                              ),
                            )
                      : CenterCircularLoader(),
                )
              else if (selectedFilter == transferFromOperation) // ignore: sdk_version_ui_as_code
                  Container(
                    height: MediaQuery.of(context).size.height -
                        (MediaQuery.of(context).size.height / 4),
                    child: transferFromLogList != null
                        ? transferFromLogList.length > 0
                        ? ListView.builder(
                      itemCount: transferFromLogList.length,
                      padding: EdgeInsets.only(
                          bottom:
                          MediaQuery.of(context).size.height / 25),
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                    color:
                                    Color.fromRGBO(69, 57, 137, .1),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                alignment: Alignment.center,
                                width:
                                MediaQuery.of(context).size.width,
                                height: 40.0,
                                margin: EdgeInsets.only(
                                    right: 20.0, left: 20.0, top: 25),
                                child: Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                  MainAxisAlignment.end,
                                  children: <Widget>[
                                    Container(
                                      margin:
                                      EdgeInsets.only(right: 20.0),
                                      child: Text(
                                        'نوع الدفع: '
                                            '${transferFromLogList[index]['is_bank'] == 1 ? bank : transferFromLogList[index]["is_sadad"] == 1 ? rasseed : transferFromLogList[index]["is_mada"] == 1 ? mada : transferFromLogList[index]["is_visa"] == 1 ? visa : 'غير معروف'}',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.black),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                      EdgeInsets.only(right: 10.0),
                                      child: Text(
                                        'تاريخ الطلب: '
                                            '${transferFromLogList[index]['creation'] != null ? transferFromLogList[index]['creation'].toString().substring(0, 10) : 'غير معروف'}',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(top: 20.0),
                                  height: transferFromLogList[index]
                                  ['items']
                                      .length %
                                      2 ==
                                      0
                                      ? ((transferFromLogList[index]
                                  ['items']
                                      .length /
                                      2) *
                                      (MediaQuery.of(context)
                                          .size
                                          .height /
                                          3.2))
                                      : (transferFromLogList[index]['items']
                                      .length *
                                      (MediaQuery.of(context)
                                          .size
                                          .height /
                                          3.2)),
                                  width:
                                  MediaQuery.of(context).size.width,
                                  child: selectedFilter == buyingOperation
                                      ? transferFromWidget(transferFromLogList[index]['items'])
                                      : Container(height: 100)),
                            ],
                          ),
                        );
                      },
                    )
                        : Container(
                      child: Center(
                        child: Text('لا يوجد بيانات لعرضها!'),
                      ),
                    )
                        : CenterCircularLoader(),
                  )



              else if (selectedFilter == transferToOperation)// ignore: sdk_version_ui_as_code
                    Container(
                      height: MediaQuery.of(context).size.height -
                          (MediaQuery.of(context).size.height / 4),
                      child: transferToLogList != null
                          ? transferToLogList.length > 0
                          ? ListView.builder(
                        itemCount: transferToLogList.length,
                        padding: EdgeInsets.only(
                            bottom:
                            MediaQuery.of(context).size.height / 25),
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                      color:
                                      Color.fromRGBO(69, 57, 137, .1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  alignment: Alignment.center,
                                  width:
                                  MediaQuery.of(context).size.width,
                                  height: 40.0,
                                  margin: EdgeInsets.only(
                                      right: 20.0, left: 20.0, top: 25),
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                    MainAxisAlignment.end,
                                    children: <Widget>[
                                      Container(
                                        margin:
                                        EdgeInsets.only(right: 20.0),
                                        child: Text(
                                          'نوع الدفع: '
                                              '${transferToLogList[index]['is_bank'] == 1 ? bank : transferToLogList[index]["is_sadad"] == 1 ? rasseed : transferToLogList[index]["is_mada"] == 1 ? mada : transferToLogList[index]["is_visa"] == 1 ? visa : 'غير معروف'}',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.black),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                        EdgeInsets.only(right: 10.0),
                                        child: Text(
                                          'تاريخ الطلب: '
                                              '${transferToLogList[index]['creation'] != null ? transferToLogList[index]['creation'].toString().substring(0, 10) : 'غير معروف'}',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                    margin: EdgeInsets.only(top: 20.0),
                                    height: transferToLogList[index]
                                    ['items']
                                        .length %
                                        2 ==
                                        0
                                        ? ((transferToLogList[index]
                                    ['items']
                                        .length /
                                        2) *
                                        (MediaQuery.of(context)
                                            .size
                                            .height /
                                            3.2))
                                        : (transferToLogList[index]['items']
                                        .length *
                                        (MediaQuery.of(context)
                                            .size
                                            .height /
                                            3.2)),
                                    width:
                                    MediaQuery.of(context).size.width,
                                    child: selectedFilter == buyingOperation
                                        ? transferToWidget(transferToLogList[index]['items'])
                                        : Container(height: 100)),
                              ],
                            ),
                          );
                        },
                      )
                          : Container(
                        child: Center(
                          child: Text('لا يوجد بيانات لعرضها!'),
                        ),
                      )
                          : CenterCircularLoader(),
                    )




            ],
          ),
        ),
      ),
    );
  }
}
