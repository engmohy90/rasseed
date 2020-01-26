import 'package:flutter/material.dart';


class Registerlang extends StatefulWidget {
  @override
  _RegisterlangState createState() => _RegisterlangState();
}

class _RegisterlangState extends State<Registerlang> {
  String _value ;
  int valuechanged = 0;
  var finalresult = 0.0;
  int valuechanged2 = 0;
  var finalresult2 = 0.0;
  void valuechangedfunc(int value) {
    setState(() {
      valuechanged = value;
      if (valuechanged == 0) {
      } else if (valuechanged == 1) {}
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            child: Icon(Icons.credit_card,color: Colors.white,size: 60.0,),
                        ),
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
              padding: const EdgeInsets.only(top: 150, right: 30, left: 30),
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
                                            margin: EdgeInsets.only(top: 50.0,right: 20.0),
                                            child: Text("أدخل الرمز المرسل إليك عبر جوالك اللغه",style: TextStyle(fontSize: 15.0,color: Colors.black),),
                                          ),

                                          Container(
                                            alignment: Alignment.topRight,
                                            margin: EdgeInsets.only(top: 10.0,right: 20.0),
                                            width: MediaQuery.of(context).size.width/3,
                                            height: 80,
                                            child: DropdownButton<String>(
                                              items: [
                                                DropdownMenuItem<String>(
                                                  child: Text('اللغه العربيه'),
                                                  value: 'Arbic',
                                                ),
                                                DropdownMenuItem<String>(
                                                  child: Text('English'),
                                                  value: 'English',
                                                ),
                                              ],
                                              onChanged: (String value) {
                                                setState(() {
                                                  _value = value;
                                                });
                                              },
                                              hint: Text('Select Item'),
                                              value: _value,
                                            ),
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
                                                alignment: Alignment.centerRight),
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
                                                      activeColor: Color.fromRGBO(
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
                                                      activeColor: Color.fromRGBO(
                                                          69, 57, 137, 1.0),
                                                      value: 2,
                                                      groupValue: valuechanged,
                                                      onChanged: valuechangedfunc)
                                                ],
                                              ),
                                            ),
                                          ),

                                          SizedBox(
                                            height: MediaQuery.of(context).size.height / 40,
                                          ),
                                          GestureDetector(
                                            onTap: () {},
                                            child: Center(
                                              child: Container(
                                                decoration: BoxDecoration(                                                color: Color.fromRGBO(69, 57, 137, 1.0),
                                                      borderRadius: BorderRadius.circular(10)),
                                                width: MediaQuery.of(context).size.width/2,
                                                  child: Center(
                                                    child: Text("تسجيل دخول",
                                                        style: TextStyle(
                                                            color: Colors.white, fontSize: 24)),
                                                  ),
                                                  alignment: Alignment.centerRight),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 20),
                                          ),
                                        ],
                                      ),
                                    ),
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
                                    child: Icon(Icons.account_circle,color: Colors.white,size: 60,),
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
