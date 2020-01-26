import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rasseed/screens/Home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataEdit extends StatefulWidget {
  @override
  _DataEditState createState() => _DataEditState();
}

class _DataEditState extends State<DataEdit> {
  TextEditingController _name = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _phone = new TextEditingController();
  bool loading = false;

  GlobalKey<ScaffoldState> dataEditScaffoldKey = GlobalKey();

  Future<String> getUserSID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('\n\n\n user sid: ${prefs.getString('client_auth')}\n\n\n');
    return prefs.getString('client_auth');
  }

  Future<String> getClientName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("full_name");
  }

  Future<String> getClientEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("email");
  }

  Future<String> getClientPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("phone");
  }
  void addValueToShared({String key, String value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  @override
  void initState() {
    super.initState();
    getClientName().then((savedClientName) => setState(() =>
        savedClientName != null
            ? _name.text = savedClientName
            : _name.text = ''));
    getClientEmail().then((savedClientEmail) => setState(() =>
        savedClientEmail != null
            ? _email.text = savedClientEmail
            : _email.text = ''));
    getClientPhone().then((savedClientPhone) => setState(() =>
        savedClientPhone != null
            ? _phone.text = savedClientPhone
            : _phone.text = '5xxxxxxxx'));
  }

  Future<String> edit_profile(String savedSID) async {

    setState(() {
      loading = true;
    });

    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(
        "https://app.rasseed.com/api/method/ash7anly.mobile_api.edit_profile?"));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode({
      "sid": savedSID,
      "data":
          "{\"email\": \"${_email.text}\", \"full_name\": \"${_name.text}\"}"
    })));
    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    String replay = await response.transform(utf8.decoder).join();
    httpClient.close();
    print("${replay}dssaaadxxsd");

    print("ggggg${response.statusCode}");

    print("ggggg${response.statusCode}");
    if (response.statusCode == 200) {

      addValueToShared(
        key: 'full_name',
        value: _name.text,
      );
      addValueToShared(
        key: 'email',
        value: _email.text,
      );
      setState(() {
        loading = false;
      });
      _showDialog(" تم التحديث بنجاح");
    } else {
      setState(() {
        loading = false;
      });
      _showDialog(" تم التحديث بنجاح");
    }

    return "done";
  }

  void _showDialog(String message) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("نجاح"),
          content: new Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("موافق"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Home_screen()));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: dataEditScaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color.fromRGBO(69, 57, 137, 1.0),
        centerTitle: true,
        title: Text(
          "البيانات الشخصيه",
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
          margin: EdgeInsets.only(top: 25.0, left: 20.0, right: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                child: Text(
                  "الاسم",
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                      fontSize: 15),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(.5)),
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(10.0)),
                  keyboardType: TextInputType.text,
                  textDirection: TextDirection.rtl,
                  controller: _name,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 17.0),
                child: Text(
                  "البريد الاليكترونى",
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                      fontSize: 15),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(.5)),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(15.0)),
                  keyboardType: TextInputType.emailAddress,
                  textDirection: TextDirection.rtl,
                  controller: _email,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 17.0),
                child: Text(
                  "رقم الجوال",
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                      fontSize: 15),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(.5)),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(15.0)),
                  keyboardType: TextInputType.text,
                  textDirection: TextDirection.rtl,
                  controller: _phone,
                ),
              ),Container(
                margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width / 4,
                    top: 40.0,
                    right: MediaQuery.of(context).size.width / 4,
                    bottom: MediaQuery.of(context).size.width / 4,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    border:
                        Border.all(color: Color.fromRGBO(69, 57, 137, 1.0))),
                child:
                loading
                    ? Center(child: new CircularProgressIndicator())
                    :InkWell(
                  splashColor: Colors.white,
                  highlightColor: Colors.white,
                  onTap: () {
                    _name.text != null && _name.text.length > 0
                        ? _email.text != null && _email.text.length > 0
                            ? getUserSID()
                                .then((savedSID) => edit_profile(savedSID))
                            : dataEditScaffoldKey.currentState.showSnackBar(
                                SnackBar(content: Text('يجب ادخال ايميلك!!')))
                        : dataEditScaffoldKey.currentState.showSnackBar(
                            SnackBar(content: Text('يجب ادخال الاسم!!')));
                  },
                  child: Text(
                          "تحديث",
                          style: TextStyle(
                              color: Color.fromRGBO(69, 57, 137, 1.0),
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
