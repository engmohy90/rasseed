import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

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

  transfer(){
    if(bankSelected.isNotEmpty){
      setState(() {
        bankColor = Colors.grey.withOpacity(.5);
        bankInput = true;
      });
    }else{
      setState(() {
        bankColor = Colors.red.withOpacity(.5);
        bankInput = false;
      });
    }

    if(fullName.text.toString().isNotEmpty){
      setState(() {
        nameColor = Colors.grey.withOpacity(.5);
        nameInput = true;
      });
    }else{
      setState(() {
        nameColor = Colors.red.withOpacity(.5);
        nameInput = false;
      });
    }
    if(cardNumber.text.toString().isNotEmpty){
      setState(() {
        cardColor = Colors.grey.withOpacity(.5);
        cardInput = true;
      });
    }else{
      setState(() {
        cardColor = Colors.red.withOpacity(.5);
        cardInput = false;
      });
    }
    if(amount.text.toString().isNotEmpty){
      setState(() {
        amountColor = Colors.grey.withOpacity(.5);
        amountInput = true;
      });
    }else{
      setState(() {
        amountColor = Colors.red.withOpacity(.5);
        amountInput = false;
      });
    }
    if(notes.text.toString().isNotEmpty){
      setState(() {
        notesColor = Colors.grey.withOpacity(.5);
        notesInput = true;
      });
    }else{
      setState(() {
        notesColor = Colors.red.withOpacity(.5);
        notesInput = false;
      });
    }


    if(notesInput && amountInput && cardInput && nameInput && bankInput){
      print("valid");
    }
  }
  openList(){
    showDialog(
        context: context,
      builder: (context)=> AlertDialog(
        content: Container(
          height: MediaQuery.of(context).size.height/4,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: Text("Banks",style: TextStyle(color: Color.fromRGBO(69, 57, 137, 1.0),fontSize: 25),textAlign: TextAlign.center,),
        ),
      )
    );
  }
  String bankSelected = "";
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Color.fromRGBO(69, 57, 137, 1.0));
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color.fromRGBO(69, 57, 137, 1.0),
        centerTitle: true,
        title: Text("تحويل بنكى",style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.w600),),
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20.0),
                alignment: Alignment.centerRight,
                child: Text("من بطاقه",style: TextStyle(fontWeight: FontWeight.w400,color: Color.fromRGBO(69, 57, 137, 1.0),fontSize: 18),),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: .5,
                color: Colors.grey.withOpacity(.5),
              ),
              Container(
                margin: EdgeInsets.only(right: 20,left: 20,top: 20,bottom: 7),
                alignment: Alignment.centerRight,
                child: Text("البنك",style: TextStyle(fontWeight: FontWeight.w400,color: Color.fromRGBO(69, 57, 137, 1.0),fontSize: 15),),
              ),
              Container(
                margin: EdgeInsets.only(left: 15,right: 15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: bankColor)
                ),
                child: Container(
                  margin: EdgeInsets.only(left: 10.0),
                  child:  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: IconButton(icon: Icon(Icons.arrow_drop_down,size: 20,), onPressed: (){
                              openList();
                        }),
                      ),
                      Container(
                        child: Text("${bankSelected}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 15),),
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.only(right: 20,left: 20,top: 20,bottom: 7),
                alignment: Alignment.centerRight,
                child: Text("الاسم كامل",style: TextStyle(fontWeight: FontWeight.w400,color: Color.fromRGBO(69, 57, 137, 1.0),fontSize: 15),),
              ),
              Container(
                margin: EdgeInsets.only(left: 15,right: 15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: nameColor)
                ),
                child: Container(
                  margin: EdgeInsets.only(left: 10.0),
                  child: TextField(
                    onChanged: (_){
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
                margin: EdgeInsets.only(right: 20,left: 20,top: 20,bottom: 7),
                alignment: Alignment.centerRight,
                child: Text("رقم البطاقه",style: TextStyle(fontWeight: FontWeight.w400,color: Color.fromRGBO(69, 57, 137, 1.0),fontSize: 15),),
              ),
              Container(
                margin: EdgeInsets.only(left: 15,right: 15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: cardColor)
                ),
                child: Container(
                  margin: EdgeInsets.only(left: 10.0),
                  child: TextField(
                    onChanged: (_){
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
                margin: EdgeInsets.only(right: 20,left: 20,top: 20,bottom: 7),
                alignment: Alignment.centerRight,
                child: Text("المبلغ",style: TextStyle(fontWeight: FontWeight.w400,color: Color.fromRGBO(69, 57, 137, 1.0),fontSize: 15),),
              ),
              Container(
                margin: EdgeInsets.only(left: 15,right: 15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: amountColor)
                ),
                child: Container(
                  margin: EdgeInsets.only(left: 10.0),
                  child: TextField(
                    onChanged: (_){
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
                margin: EdgeInsets.only(right: 20,left: 20,top: 20,bottom: 7),
                alignment: Alignment.centerRight,
                child: Text("ملاحظات",style: TextStyle(fontWeight: FontWeight.w400,color: Color.fromRGBO(69, 57, 137, 1.0),fontSize: 15),),
              ),
              Container(
                margin: EdgeInsets.only(left: 15,right: 15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: notesColor)
                ),
                child: Container(
                  margin: EdgeInsets.only(left: 10.0),
                  child: TextField(
                    onChanged: (_){
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
                margin: EdgeInsets.only(right: 20,left: 20,top: 20,bottom: 7),
                alignment: Alignment.centerRight,
                child: Text("الى بطاقة",style: TextStyle(fontWeight: FontWeight.w400,color: Color.fromRGBO(69, 57, 137, 1.0),fontSize: 15),),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: .5,
                color: Colors.grey.withOpacity(.5),
              ),
              Container(
                margin: EdgeInsets.only(right: 20,left: 20,top: 15,bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    InkWell(
                      child: Container(
                           child: Text("تغير",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,color: Color.fromRGBO(69, 57, 137, 1.0)),)
                      ),
                    ),
                    Container(
                         child: Text("بنك الراجحى",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 17),)
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 20,left: 20,top: 10,bottom: 0),
                alignment: Alignment.centerRight,
                child: Text("اسم الحساب: بطاقات الشبكه الاساسيه",style: TextStyle(fontWeight: FontWeight.w400,color: Color.fromRGBO(69, 57, 137, 1.0),fontSize: 15)),
              ),
              Container(
                margin: EdgeInsets.only(right: 20,left: 20,top: 10,bottom: 0),
                alignment: Alignment.centerRight,
                child: Text("رقم الحساب:5384152315890157956",style: TextStyle(fontWeight: FontWeight.w400,color: Color.fromRGBO(69, 57, 137, 1.0),fontSize: 15)),
              ),
              Container(
                margin: EdgeInsets.only(right: 20,left: 20,top: 10,bottom: 0),
                alignment: Alignment.centerRight,
                child: Text("رقم الحساب المصرفى:5384152315890157956",style: TextStyle(fontWeight: FontWeight.w400,color: Color.fromRGBO(69, 57, 137, 1.0),fontSize: 15)),
              ),
              Container(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: (){
                    transfer();
                  },
                  highlightColor: Colors.white,
                  splashColor: Colors.white,
                  child: Container(
                    width: MediaQuery.of(context).size.width/3,
                    height: 35,
                    margin: EdgeInsets.only(top: 30,bottom: 15.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(69, 57, 137, 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    child: Text("تحويل",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w400),),
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
