import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

class DepositBalance extends StatefulWidget {
  @override
  _DepositBalanceState createState() => _DepositBalanceState();
}

class _DepositBalanceState extends State<DepositBalance> {
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Color.fromRGBO(69, 57, 137, 1.0));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color.fromRGBO(69, 57, 137, 1.0),
        centerTitle: true,
        title: Text("كشف حساب",style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.w600),),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.arrow_forward_ios, color: Colors.white,size: 20.0,), onPressed: (){
            Navigator.pop(context);
          }),
        ],
        leading: Container(
          color: Color.fromRGBO(69, 57, 137, 1.0),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(69, 57, 137, 1.0),
              ),
              height: MediaQuery.of(context).size.height/4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(margin: EdgeInsets.only(top: 7.0,right: 2.0),child: Text('رس',style: TextStyle(color:Colors.white,fontWeight: FontWeight.w300,fontSize: 15),),),
                          Container(child: Text("200.65",style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.w400),),),
                        ],
                      ),
                    ),
                   Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[

                        Container(
                          alignment: Alignment.center,
//                          width: 120.0,
                          child: InkWell(
                            child: Container(
                              margin: EdgeInsets.only(right: 20.0),
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(69, 57, 137, 1.0),
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                border: Border.all(color: Colors.white),
                              ),
                              child: Text("حوالات",style: TextStyle(fontWeight: FontWeight.w400,color: Colors.white,fontSize: 16),),
                            ),
                          ),
                        ),
                        Container(
                          child: InkWell(
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(69, 57, 137, 1.0),
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                border: Border.all(color: Colors.white)
                              ),
                              child: Text("إيداع رصيد",style: TextStyle(fontWeight: FontWeight.w400,color: Colors.white,fontSize: 16),),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 15.0,left: 12.0,right: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("ارشفة لجميع حركات السحب و الإضافه لحسابك",style: TextStyle(color: Color.fromRGBO(69, 57, 137, 1.0),fontSize: 15),),
                      Text("في رصيد",style: TextStyle(color: Color.fromRGBO(69, 57, 137, 1.0),fontSize: 15),)
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(left: 20.0,top: 7.0),
                          child:Text("-100",style: TextStyle(fontSize: 15.0,color: Colors.red.withOpacity(1.0),fontWeight: FontWeight.w400),)
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              child: Text("شراء بطاقة موبايلى من رصيدي",style: TextStyle(color: Color.fromRGBO(69, 57, 137, 1.0),fontSize: 15),),
                            ),
                            Container(
                              child: Text("التاريخ 13-08-2019",style: TextStyle(color: Color.fromRGBO(69, 57, 137, 1.0),fontSize: 12),),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  width: MediaQuery.of(context).size.width,
                  height: .5,
                  color: Colors.grey.withOpacity(.5),
                ),

                Container(
                  margin: EdgeInsets.only(top: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(left: 20.0,top: 7.0),
                          child:Text("-100",style: TextStyle(fontSize: 15.0,color: Colors.red.withOpacity(1.0),fontWeight: FontWeight.w400),)
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              child: Text("شراء بطاقة موبايلى من رصيدي",style: TextStyle(color: Color.fromRGBO(69, 57, 137, 1.0),fontSize: 15),),
                            ),
                            Container(
                              child: Text("التاريخ 13-08-2019",style: TextStyle(color: Color.fromRGBO(69, 57, 137, 1.0),fontSize: 12),),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  width: MediaQuery.of(context).size.width,
                  height: .5,
                  color: Colors.grey.withOpacity(.5),
                ),

                Container(
                  margin: EdgeInsets.only(top: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(left: 20.0,top: 7.0),
                          child:Text("+450",style: TextStyle(fontSize: 15.0,color:Color.fromRGBO(118, 182, 47, 1.0),fontWeight: FontWeight.w400),)
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              child: Text("إضافه مبلغ لرصيدي",style: TextStyle(color: Color.fromRGBO(69, 57, 137, 1.0),fontSize: 15),),
                            ),
                            Container(
                              child: Text("التاريخ 13-08-2019",style: TextStyle(color: Color.fromRGBO(69, 57, 137, 1.0),fontSize: 12),),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  width: MediaQuery.of(context).size.width,
                  height: .5,
                  color: Colors.grey.withOpacity(.5),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
