import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:rasseed/functions/shared_services.dart';
import 'package:rasseed/utils/bottom_sheet_customize.dart';

class PaymentMethod extends StatefulWidget {
  @override
  _PaymentMethodState createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  String paymentMethod;

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Color.fromRGBO(69, 57, 137, 1.0));

    getPaymentMethodName().then((savedPaymentMethod) => setState(() {
          paymentMethod = savedPaymentMethod ?? '';
          print('\n\n fdgjk payment: $paymentMethod \n\n\n');
        }));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(69, 57, 137, 1.0),
        centerTitle: true,
        title: Text(
          "اختيار طريقه دفع",
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
              child: Text(
                "طرق الدفع المتوفرة",
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
            InkWell(
              onTap: () =>
                  addPaymentMethodName('مدى').then((valueSaved) => valueSaved
                      ? Navigator.pop(context)
                      : showRoundedModalBottomSheet(
                          autoResize: true,
                          dismissOnTap: false,
                          context: context,
                          radius: 20.0,
                          // This is the default
                          color: Colors.white,
                          // Also default
                          builder: (context) => Container(
                                alignment: Alignment.topRight,
                                margin: EdgeInsets.only(top: 15, right: 20),
                                child: Text(
                                  'لم يتم حفظ طريقة الدفع, برجاء المحاولة ثانية!',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                ),
                              ))),
              child: Container(
                margin: EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    paymentMethod != null && paymentMethod == "مدى"
                        ? Container(
                            margin: EdgeInsets.only(left: 15.0, top: 10.0),
                            child: Icon(Icons.check,
                                size: 25,
                                color: Color.fromRGBO(69, 57, 137, 1.0)),
                          )
                        : Container(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 25.0),
                          child: Text("مدى",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(69, 57, 137, 1.0),
                                  fontSize: 15)),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 15.0),
                          child: Icon(
                            Icons.credit_card,
                            size: 40,
                            color: Color.fromRGBO(69, 57, 137, 1.0),
                          ),
                        ),
                      ],
                    ),
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
              onTap: () => addPaymentMethodName('ابل باى')
                  .then((valueSaved) => valueSaved
                      ? Navigator.pop(context)
                      : showRoundedModalBottomSheet(
                          autoResize: true,
                          dismissOnTap: false,
                          context: context,
                          radius: 20.0,
                          // This is the default
                          color: Colors.white,
                          // Also default
                          builder: (context) => Container(
                                alignment: Alignment.topRight,
                                margin: EdgeInsets.only(top: 15, right: 20),
                                child: Text(
                                  'لم يتم حفظ طريقة الدفع, برجاء المحاولة ثانية!',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                ),
                              ))),
              child: Container(
                margin: EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    paymentMethod != null && paymentMethod == 'ابل باى'
                        ? Container(
                            margin: EdgeInsets.only(left: 15.0, top: 10.0),
                            child: Icon(Icons.check,
                                size: 25,
                                color: Color.fromRGBO(69, 57, 137, 1.0)),
                          )
                        : Container(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 25.0),
                          child: Text("ابل باى",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(69, 57, 137, 1.0),
                                  fontSize: 15)),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 15.0),
                          child: Icon(
                            Icons.credit_card,
                            size: 40,
                            color: Color.fromRGBO(69, 57, 137, 1.0),
                          ),
                        ),
                      ],
                    ),
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
              onTap: () => addPaymentMethodName('حواله بنكية')
                  .then((valueSaved) => valueSaved
                      ? Navigator.pop(context)
                      : showRoundedModalBottomSheet(
                          autoResize: true,
                          dismissOnTap: false,
                          context: context,
                          radius: 20.0,
                          // This is the default
                          color: Colors.white,
                          // Also default
                          builder: (context) => Container(
                                alignment: Alignment.topRight,
                                margin: EdgeInsets.only(top: 15, right: 20),
                                child: Text(
                                  'لم يتم حفظ طريقة الدفع, برجاء المحاولة ثانية!',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                ),
                              ))),
              child: Container(
                margin: EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    paymentMethod != null && paymentMethod == 'حواله بنكية'
                        ? Container(
                            margin: EdgeInsets.only(left: 15.0, top: 10.0),
                            child: Icon(Icons.check,
                                size: 25,
                                color: Color.fromRGBO(69, 57, 137, 1.0)),
                          )
                        : Container(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 25.0),
                          child: Text("حواله بنكية",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(69, 57, 137, 1.0),
                                  fontSize: 15)),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 15.0),
                          child: Icon(
                            Icons.credit_card,
                            size: 40,
                            color: Color.fromRGBO(69, 57, 137, 1.0),
                          ),
                        ),
                      ],
                    ),
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
              onTap: () => addPaymentMethodName('رصيدي')
                  .then((valueSaved) => valueSaved
                      ? Navigator.pop(context)
                      : showRoundedModalBottomSheet(
                          autoResize: true,
                          dismissOnTap: false,
                          context: context,
                          radius: 20.0,
                          // This is the default
                          color: Colors.white,
                          // Also default
                          builder: (context) => Container(
                                alignment: Alignment.topRight,
                                margin: EdgeInsets.only(top: 15, right: 20),
                                child: Text(
                                  'لم يتم حفظ طريقة الدفع, برجاء المحاولة ثانية!',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                ),
                              ))),
              child: Container(
                margin: EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    paymentMethod != null && paymentMethod == 'رصيدي'
                        ? Container(
                            margin: EdgeInsets.only(left: 15.0, top: 10.0),
                            child: Icon(Icons.check,
                                size: 25,
                                color: Color.fromRGBO(69, 57, 137, 1.0)),
                          )
                        : Container(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 25.0),
                          child: Text("رصيدي",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(69, 57, 137, 1.0),
                                  fontSize: 15)),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 15.0),
                          child: Icon(
                            Icons.credit_card,
                            size: 40,
                            color: Color.fromRGBO(69, 57, 137, 1.0),
                          ),
                        ),
                      ],
                    ),
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
//            InkWell(
//              onTap: () {
//                Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                        builder: (context) => EditPaymentMethod()));
//              },
//              child: Container(
//                margin: EdgeInsets.only(top: 15.0, right: 20),
//                alignment: Alignment.centerRight,
//                child: Text("اضافه طريقة دفع جديدة",
//                    style: TextStyle(
//                        fontWeight: FontWeight.w400,
//                        color: Color.fromRGBO(69, 57, 137, 1.0),
//                        fontSize: 15)),
//              ),
//            ),
          ],
        ),
      ),
    );
  }
}
