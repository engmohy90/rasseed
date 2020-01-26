  import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:rasseed/screens/payment/PaymentMethodData.dart';

class EditPaymentMethod extends StatefulWidget {
  @override
  _EditPaymentMethodState createState() => _EditPaymentMethodState();
}

class _EditPaymentMethodState extends State<EditPaymentMethod> {
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
      body: Container(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20.0),
              alignment: Alignment.centerRight,
              child: Text("طرق الدفع المتوفرة",style: TextStyle(fontWeight: FontWeight.w400,color: Color.fromRGBO(69, 57, 137, 1.0),fontSize: 15),),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: .5,
              color: Colors.grey.withOpacity(.5),
            ),
            InkWell(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaymentMethodData()));
              },
              child: Container(
                margin: EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    Container(
                      margin: EdgeInsets.only(left: 15.0,top: 10.0),
                      child: Icon(Icons.arrow_back_ios,size: 25,color:Color.fromRGBO(69, 57, 137, 1.0)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 25.0),
                          child: Text("1222****",style: TextStyle(fontWeight: FontWeight.w400,color: Color.fromRGBO(69, 57, 137, 1.0),fontSize: 15)),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 15.0),
                          child: Icon(Icons.credit_card,size: 40,color: Color.fromRGBO(69, 57, 137, 1.0),),
                        ),
                      ],
                    )  ,
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15.0),
              width: MediaQuery.of(context).size.width,
              height: .5,
              color: Colors.grey.withOpacity(.5),
            ),
            InkWell(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaymentMethodData()));
              },
              child: Container(
                margin: EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    Container(
                      margin: EdgeInsets.only(left: 15.0,top: 10.0),
                      child: Icon(Icons.arrow_back_ios,size: 25,color:Color.fromRGBO(69, 57, 137, 1.0)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 25.0),
                          child: Text("ابل باى",style: TextStyle(fontWeight: FontWeight.w400,color: Color.fromRGBO(69, 57, 137, 1.0),fontSize: 15)),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 15.0),
                          child: Icon(Icons.credit_card,size: 40,color: Color.fromRGBO(69, 57, 137, 1.0),),
                        ),
                      ],
                    )  ,
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15.0),
              width: MediaQuery.of(context).size.width,
              height: .5,
              color: Colors.grey.withOpacity(.5),
            ),
            InkWell(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaymentMethodData()));
              },
              child: Container(
                margin: EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    Container(
                      margin: EdgeInsets.only(left: 15.0,top: 10.0),
                      child: Icon(Icons.arrow_back_ios,size: 25,color:Color.fromRGBO(69, 57, 137, 1.0)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 25.0),
                          child: Text("حواله بنكية",style: TextStyle(fontWeight: FontWeight.w400,color: Color.fromRGBO(69, 57, 137, 1.0),fontSize: 15)),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 15.0),
                          child: Icon(Icons.credit_card,size: 40,color: Color.fromRGBO(69, 57, 137, 1.0),),
                        ),
                      ],
                    )  ,
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15.0),
              width: MediaQuery.of(context).size.width,
              height: .5,
              color: Colors.grey.withOpacity(.5),
            ),

          ],
        ),
      ),
    );
  }
}
