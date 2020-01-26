import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

class FailPayfort extends StatefulWidget {
  @override
  _FailPayfortState createState() => _FailPayfortState();
}

class _FailPayfortState extends State<FailPayfort> {
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Color.fromRGBO(69, 57, 137, 1.0));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(69, 57, 137, 1.0),
        centerTitle: true,
        title: Text("فشل الدفع >> التواصل وتس",style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.w600),),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.close, color: Colors.white,size: 20.0,), onPressed: (){
            Navigator.of(context).pop();
          }),
        ],
        leading: Container(
          color: Color.fromRGBO(69, 57, 137, 1.0),
        ),
      )

      );

  }
}
