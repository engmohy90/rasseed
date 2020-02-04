import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rasseed/utils/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ShopCard.dart';

class pervious_cards extends StatefulWidget {
  @override
  _pervious_cardsState createState() => _pervious_cardsState();
}

class _pervious_cardsState extends State<pervious_cards> {
//  List image_data = [
//    'assets/image1.jpg',
//  ];
  List<Map<String, dynamic>> cardsDataList = List();

  /// "https://www.rasseed.com/api/method/ash7anly.api.operators_with_pin?sid=get_the_value_from_activate"
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
  Future<String> getUserSID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('\n\n\n user sid: ${prefs.getString('client_auth')}\n\n\n');
    return await prefs.getString('client_auth');
  }

  Future<String> getPreviousCards(String sid) async {
    Loader.showUnDismissibleLoader(context);

    /// todo endpoint
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(
        "https://www.rasseed.com/api/method/ash7anly.api.operators_with_pin?"));
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
      if(json.decode(replay)['message']!= null)json.decode(replay)['message'].forEach((cardData) {
        setState(() => cardsDataList.add(cardData));
      });
    } else {
      Loader.hideDialog(context);
      // error
    }

    print('\n\ncard list length: ${cardsDataList.length}\n\n');
  }

  @override
  void initState() {
    super.initState();
    getUserSID().then((savedSID) => getPreviousCards(savedSID));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20.0, left: 8.0, right: 8.0),
            height: MediaQuery.of(context).size.height / 1.5,
            width: MediaQuery.of(context).size.width,
            child: cardsDataList != null
                ? GridView.builder(
                    itemCount: cardsDataList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 3,
                        crossAxisCount: 2,
                        crossAxisSpacing: 3),
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ShopCard(cardsDataList[index],isNewCard:false),
                          ),
                        );
                      },
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width / 4,
                              height: MediaQuery.of(context).size.height / 8,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    Uri.encodeFull(
                                        "https://www.rasseed.com${cardsDataList[index]['logo']}"),
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
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
//                              color: Color.fromRGBO(69, 57, 137, 1.0),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    '${cardsDataList[index]['value']}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 4,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
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
                                          '${cardsDataList[index]['pin']}',
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
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(
                    child: Text(
                      'لا يوجد بيانات...',
                      textAlign: TextAlign.center,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
