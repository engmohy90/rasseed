 import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

import 'PaymentMethod.dart';

class PaymentMethodData extends StatefulWidget {
  @override
  _PaymentMethodDataState createState() => _PaymentMethodDataState();
}

class _PaymentMethodDataState extends State<PaymentMethodData> {
  TextEditingController _cardNumber = new TextEditingController();
  TextEditingController _cvv = new TextEditingController();
  TextEditingController _expireDate = new TextEditingController();
  TextEditingController _country = new TextEditingController();

  Color _cardNumberColor = Colors.grey.withOpacity(.5);
  Color _cvvColor = Colors.grey.withOpacity(.5);
  Color _expireDataColor = Colors.grey.withOpacity(.5);
  Color _countryColor = Colors.grey.withOpacity(.5);

  bool _cardNumberImput = false;
  bool _cvvImput = false;
  bool _expireDataImput = false;
  bool _countryInput = false;

  addPaymentMethod(){
    if(_cardNumber.text.toString().isNotEmpty){
      setState(() {
        _cardNumberColor = Colors.grey.withOpacity(.5);
        _cardNumberImput = true;
      });
    }else{
     setState(() {
       _cardNumberColor = Colors.red.withOpacity(.5);
       _cardNumberImput = false;
     });
    }
    if(_cvv.text.toString().isNotEmpty){
     setState(() {
       _cvvColor = Colors.grey.withOpacity(.5);
       _cvvImput = true;
     });
    }else{
      setState(() {
        _cvvColor = Colors.red.withOpacity(.5);
        _cvvImput = false;
      });
    }
    if(_expireDate.text.toString().isNotEmpty){
     setState(() {
       _expireDataColor = Colors.grey.withOpacity(.5);
       _expireDataImput = true;
     });
    }else{
     setState(() {
       _expireDataColor = Colors.red.withOpacity(.5);
       _expireDataImput = false;
     });
    }
    if(_country.text.toString().isNotEmpty){
      setState(() {
        _countryColor = Colors.grey.withOpacity(.5);
        _countryInput = true;
      });
    }else{
      setState(() {
        _countryColor = Colors.red.withOpacity(.5);
        _countryInput = false;
      });
    }
    if(_countryInput && _expireDataImput && _cvvImput && _cardNumberImput){
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => PaymentMethod()));
    }
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Color.fromRGBO(69, 57, 137, 1.0));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(69, 57, 137, 1.0),
        centerTitle: true,
        title: Text("اضافه طريقه دفع",style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.w600),),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.arrow_forward_ios, color: Colors.white,size: 20.0,), onPressed: (){
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20.0),
                alignment: Alignment.centerRight,
                child: Text("بيانات البطاقه",style: TextStyle(fontWeight: FontWeight.w400,color: Color.fromRGBO(69, 57, 137, 1.0),fontSize: 18),),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: .5,
                color: Colors.grey.withOpacity(.5),
              ),
              Container(
                margin: EdgeInsets.only(right: 20,left: 20,top: 20,bottom: 7),
                alignment: Alignment.centerRight,
                child: Text("رقم البطاقه",style: TextStyle(fontWeight: FontWeight.w400,color: Color.fromRGBO(69, 57, 137, 1.0),fontSize: 15),),
              ),
              Container(
                margin: EdgeInsets.only(left: 15,right: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: _cardNumberColor)
                ),
                child: Container(
                  margin: EdgeInsets.only(left: 10.0),
                  child: TextField(
                    onChanged: (_){
                      setState(() {
                        _cardNumberColor = Colors.grey.withOpacity(.5);
                      });
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    controller: _cardNumber,
                    textDirection: TextDirection.ltr,
                    keyboardAppearance: Brightness.light,
                    cursorRadius: Radius.circular(15.0),
                    keyboardType: TextInputType.text,
                    autocorrect: true,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerRight,
                          child: Text("CVV",style: TextStyle(fontWeight: FontWeight.w400,color: Color.fromRGBO(69, 57, 137, 1.0),fontSize: 18),),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 15.0),
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width/3,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              border: Border.all(color: _cvvColor)
                          ),
                          child: TextField(
                            onChanged: (_){
                              setState(() {
                                _cvvColor = Colors.grey.withOpacity(.5);
                              });
                            },
                            controller: _cvv,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "124",
                              hintStyle: TextStyle(color: Colors.grey.withOpacity(.5),fontSize: 15),
                            ),
//                           maxLength: 3,
                              maxLines: 1,
                            inputFormatters:[
                              LengthLimitingTextInputFormatter(3),
                            ],
                             textDirection: TextDirection.ltr,
                            keyboardAppearance: Brightness.light,
                            cursorRadius: Radius.circular(15.0),
                            keyboardType: TextInputType.number,
                            autocorrect: true,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                           alignment: Alignment.centerRight,
                          child: Text("تاريخ الانتهاء",style: TextStyle(fontWeight: FontWeight.w400,color: Color.fromRGBO(69, 57, 137, 1.0),fontSize: 18),),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 15.0),
                          width: MediaQuery.of(context).size.width/3,
                           decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              border: Border.all(color: _expireDataColor)
                          ),
                          child: TextField(
                            onChanged: (_){
                              setState(() {
                                _expireDataColor = Colors.grey.withOpacity(.5);
                              });
                            },
                            controller: _expireDate,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: "MM/YY",
                              hintStyle: TextStyle(color: Colors.grey.withOpacity(.5),fontSize: 15),
                              border: InputBorder.none,
                            ),
                            inputFormatters:[
                              LengthLimitingTextInputFormatter(5),
                            ],
                            maxLines: 1,
                             textDirection: TextDirection.ltr,
                            keyboardAppearance: Brightness.light,
                            cursorRadius: Radius.circular(15.0),
                            keyboardType: TextInputType.number,
                            autocorrect: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 20,left: 20,top: 20,bottom: 7),
                alignment: Alignment.centerRight,
                child: Text("الدوله",style: TextStyle(fontWeight: FontWeight.w400,color: Color.fromRGBO(69, 57, 137, 1.0),fontSize: 15),),
              ),
              Container(
                margin: EdgeInsets.only(left: 15,right: 15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: _countryColor)
                ),
                child: Container(
                  margin: EdgeInsets.only(left: 10.0,right: 10.0),
                  child: TextField(
                    onChanged: (_){
                      setState(() {
                        _countryColor = Colors.grey.withOpacity(.5);
                      });
                    },
                    controller: _country,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "المملكه العربيه السعودية",
                      hintStyle: TextStyle(color: Colors.grey.withOpacity(.5),fontSize: 15),
                    ),
                    keyboardAppearance: Brightness.light,
                    cursorRadius: Radius.circular(15.0),
                    keyboardType: TextInputType.text,
                    autocorrect: true,
                  ),
                ),
              ),
              InkWell(
                splashColor: Colors.white,
                highlightColor: Colors.white,
                onTap: (){
                 addPaymentMethod();
                },
                child: Container(
                  alignment: Alignment.center,
                  child: Container(
                    width: MediaQuery.of(context).size.width/3,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      border: Border.all(color:Color.fromRGBO(69, 57, 137, 1.0)),

//                    border: Border(top: BorderSide(color: Color.fromRGBO(69, 57, 137, 1.0)),left: BorderSide(color: Color.fromRGBO(69, 57, 137, 1.0)),right: BorderSide(color: Color.fromRGBO(69, 57, 137, 1.0)),bottom: BorderSide(color: Color.fromRGBO(69, 57, 137, 1.0),width: 2.0))
                    ),
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 50.0,),
                    child: Text('إضافه',style: TextStyle(color: Color.fromRGBO(69, 57, 137, 1.0),fontSize: 15,fontWeight: FontWeight.w600),),
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
